//
//  ChatMessage.swift
//  ConvoTrack
//
//  Created by Mohaymin Islam on 2024-06-19.
//

import Foundation

struct ChatMessage: Identifiable, Codable, Equatable {
    let id: String
    let text: String
    let isUserMessage: Bool
    let timestamp: Date
}
