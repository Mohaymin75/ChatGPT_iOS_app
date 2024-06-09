//
//  ChatListViewModel.swift
//  ChatGPT
//
//  Created by Mohaymin Islam on 2024-05-22.
//

import Foundation
import SwiftUI

class ChatListViewModel: ObservableObject {
    @Published var chats: [AppChat] = []
    @Published var loadingState: ChatListState = .loading
    @Published var isPresentingNewChat = false
    @Published var newChat: AppChat?

    init() {
        fetchData()
    }
    
    func fetchData() {
        // Sample data initialization with correct Date() usage and commas
        self.chats = [
            AppChat(id: "1", topic: "Some Topic", model: .gpt3_5_turbo, lastMessageSent: Date(), owner: "123"),
            AppChat(id: "2", topic: "Some other Topic", model: .gpt4, lastMessageSent: Date(), owner: "123")
        ]
        // Update loading state after fetching data
        self.loadingState = .resultFound
    }
    
    func deleteChat(at offsets: IndexSet) {
        chats.remove(atOffsets: offsets)
    }
    
    func startNewChat() {
        // Create a new chat
        let newChat = AppChat(id: UUID().uuidString, topic: "New Chat", model: .gpt3_5_turbo, lastMessageSent: Date(), owner: "123")
        self.newChat = newChat
        self.isPresentingNewChat = true
    }
    
    func openUserSettings() {
        // TODO: Implement opening user settings
        print("Open user settings")
    }
}

enum ChatListState {
    case loading
    case noResults
    case resultFound
}

struct AppChat: Codable, Identifiable {
    let id: String
    let topic: String?
    let model: ChatModel?
    let lastMessageSent: Date
    let owner: String

    var lastMessageTimeAgo: String {
        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: lastMessageSent, to: now)
        let timeUnits: [(value: Int?, unit: String)] = [
            (components.year, "year"),
            (components.month, "month"),
            (components.day, "day"),
            (components.hour, "hour"),
            (components.minute, "minute"),
            (components.second, "second")
        ]

        for timeUnit in timeUnits {
            if let value = timeUnit.value, value > 0 {
                return "\(value) \(timeUnit.unit)\(value == 1 ? "" : "s") ago"
            }
        }
        return "just now"
    }
}

enum ChatModel: String, Codable, CaseIterable, Hashable {
    case gpt3_5_turbo = "GPT 3.5 Turbo"
    case gpt4 = "GPT 4"

    var tintColor: Color {
        switch self {
        case .gpt3_5_turbo:
            return .green
        case .gpt4:
            return .purple
        }
    }
}
