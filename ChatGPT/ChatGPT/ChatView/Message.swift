//
//  Message.swift
//  ConvoTrack
//
//  Created by Mohaymin Islam on 2024-06-20.
//

import Foundation

struct Message: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isUserMessage: Bool
}
