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
                    Button(action: viewModel.startNewChat) {
                        Image(systemName: "plus.circle")
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
            }
        }
    }
    
    private func chatEntry(_ chat: AppChat) -> some View {
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
                    .padding(.trailing, 8)
            }
            Text(chat.lastMessageTimeAgo)
                .font(.caption2)
                .foregroundColor(.gray)
                .opacity(0.6)
        }
        .padding(.vertical, 8)
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
