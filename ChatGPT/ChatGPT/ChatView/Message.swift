//
//  Message.swift
//  ChatGPT
//
//  Created by Mohaymin Islam on 2024-05-31.
//

import Foundation

struct Message: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isUserMessage: Bool
}
