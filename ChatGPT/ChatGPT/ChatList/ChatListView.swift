// ChatListView.swift
// ConvoTrack
//
// Created by Mohaymin Islam on 2024-06-19.
//



import SwiftUI
import CoreData

struct ChatListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var viewModel: ChatListViewModel
    @State private var isShowingRenamePopup = false
    @State private var newName: String = ""
    @State private var chatIdToRename: String = ""
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingTutorial = false  // New state for tutorial

    init() {
        _viewModel = StateObject(wrappedValue: ChatListViewModel(context: PersistenceController.shared.container.viewContext))
    }

    var body: some View {
        NavigationView {
            Group {
                switch viewModel.loadingState {
                case .loading:
                    Text("Loading Chats...")
                case .noResults:
                    Text("No Chats...")
                case .resultFound:
                    if viewModel.chats.isEmpty {
                        Text("No Chats Available")
                    } else {
                        chatList
                    }
                }
            }
            .navigationTitle("Chats")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingTutorial = true  // Action for tutorial button
                    }) {
                        Image(systemName: "info.circle")
                    }
                    Button(action: viewModel.startNewChat) {
                        Image(systemName: "plus.circle")
                    }
                    Button(action: themeManager.toggleTheme) {
                        Image(systemName: themeManager.isDarkMode ? "sun.max.fill" : "moon.fill")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search chats", text: $viewModel.searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
            }
            .onAppear {
                viewModel.loadData()
            }
            .sheet(isPresented: $isShowingRenamePopup) {
                VStack {
                    Text("Enter New Name")
                        .font(.headline)
                    TextField("New name", text: $newName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button("Save") {
                        if !newName.isEmpty {
                            viewModel.renameChat(chatId: chatIdToRename, newName: newName)
                            isShowingRenamePopup = false
                            newName = ""
                        }
                    }
                    .padding()
                }
                .frame(width: 300, height: 200)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 8)
            }
            .sheet(isPresented: $showingTutorial) {
                TutorialVideoView()  // Present tutorial video view
            }
        }
    }
    
    private var chatList: some View {
        List {
            ForEach(viewModel.searchChats()) { chat in
                NavigationLink(destination: ChatDetailView(viewModel: ChatDetailViewModel(chat: chat, context: viewContext))) {
                    chatEntry(chat)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        viewModel.deleteChat(at: IndexSet(integer: viewModel.chats.firstIndex(where: { $0.id == chat.id })!))
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    Button {
                        chatIdToRename = chat.id
                        newName = chat.topic ?? ""
                        isShowingRenamePopup = true
                    } label: {
                        Label("Rename", systemImage: "pencil")
                    }
                    .tint(.blue)
                }
                .listRowBackground(chat.isBookmarked ? Color.yellow.opacity(0.1) : Color.clear)
            }
        }
    }
    
    private func chatEntry(_ chat: AppChat) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(chat.topic ?? "Unknown Topic")
                        .font(.headline)
                    Spacer()
                    Text(chat.model?.rawValue ?? "")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(chat.model?.tintColor ?? .gray)
                        .padding(6)
                        .background(chat.model?.tintColor.opacity(0.1))
                        .clipShape(Capsule())
                }
                Text(chat.lastMessageTimeAgo)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .opacity(0.6)
            }
            Spacer()
            Button(action: {
                withAnimation(.spring()) {
                    viewModel.toggleBookmark(for: chat)
                }
            }) {
                Image(systemName: chat.isBookmarked ? "bookmark.fill" : "bookmark")
                    .foregroundColor(chat.isBookmarked ? .yellow : .gray)
                    .scaleEffect(chat.isBookmarked ? 1.2 : 1.0)
                    .animation(.spring(), value: chat.isBookmarked)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 8)
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(ThemeManager())
    }
}
