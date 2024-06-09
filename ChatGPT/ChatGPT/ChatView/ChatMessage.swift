//
//  ChatMessage.swift
//  ChatGPT
//
//  Created by Mohaymin Islam on 2024-05-22.
//

import Foundation

struct ChatMessage: Identifiable, Codable {
    let id: String
    let content: String
    let isUser: Bool
    let timestamp: Date
}
