//
//  AppChat.swift
//  ChatGPT
//
//  Created by Mohaymin Islam on 2024-06-20.
//

import Foundation
import SwiftUI

struct AppChat: Identifiable, Codable {
    let id: String
    var topic: String?
    let model: ChatModel?
    var lastMessageSent: Date
    let owner: String
    var messages: [ChatMessage] = []


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

// States for loading chats
enum ChatListState {
    case loading
    case noResults
    case resultFound
}

// Models of ChatGPT that can be used
enum ChatModel: String, Codable, CaseIterable {
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
