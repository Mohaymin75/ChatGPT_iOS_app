//
//  ChatModel.swift
//  ConvoTrack
//
//  Created by Mohaymin Islam on 2024-06-19.
//

import SwiftUI

enum ChatModel: String, Codable, CaseIterable {
    case gpt3_5_turbo = "GPT-3.5 Turbo"
    case gpt4 = "GPT-4"

    var tintColor: Color {
        switch self {
        case .gpt3_5_turbo:
            return .green
        case .gpt4:
            return .purple
        }
    }
}
