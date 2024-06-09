//
//  ChatListView.swift
//  ChatGPT
//
//  Created by Mohaymin Islam on 2024-05-22.
//

import SwiftUI

struct ChatListView: View {
    @StateObject var viewModel = ChatListViewModel()
    
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
                    Button(action: viewModel.openUserSettings) {
                        Image(systemName: "person.circle")
                    }
                }
            }
            .onAppear {
                viewModel.fetchData()
            }
            .sheet(isPresented: $viewModel.isPresentingNewChat) {
                if let newChat = viewModel.newChat {
                    NavigationView {
                        ChatDetailView(viewModel: ChatDetailViewModel(chat: newChat))
                    }
                }
            }
        }
    }
    
    private var chatList: some View {
        List {
            ForEach(viewModel.chats) { chat in
                NavigationLink(destination: ChatDetailView(viewModel: ChatDetailViewModel(chat: chat))) {
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
            .onDelete(perform: viewModel.deleteChat)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}
