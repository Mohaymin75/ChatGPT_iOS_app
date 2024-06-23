//
//  Models.swift
//  ConvoTrack
//
//  Created by Mohaymin Islam on 2024-06-19.
//

import SwiftUI

// This should be the only place where ChatModel is declared.
enum ChatModel: String, Codable, CaseIterable {
    case gpt3_5_turbo = "GPT-3.5 Turbo"
    case gpt4 = "GPT-4"

    var tintColor: Color {
        switch self {
        case .gpt3_5_turbo: return .green
        case .gpt4: return .purple
        }
    }
}

// This should be the only place where AppChat is declared.
struct AppChat: Identifiable {
    let id: String
    var topic: String?
    var messages: [ChatMessage]
    var model: ChatModel
    var lastMessageSent: Date
    var owner: String
}

// This should be the only place where ChatMessage is declared.
struct ChatMessage: Identifiable, Codable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
}
