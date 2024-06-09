//
//  ChatDetailViewModel.swift
//  ChatGPT
//
//  Created by Mohaymin Islam on 2024-05-22.
//

import Foundation
import SwiftUI

class ChatDetailViewModel: ObservableObject {
    @Published var chat: AppChat
    @Published var messages: [Message] = []
    @Published var userMessage: String = ""
    @Published var selectedModel: ChatModel = .gpt3_5_turbo

    private let apiService = OpenAIAPIService()

    init(chat: AppChat) {
        self.chat = chat
    }
    
    func sendMessage() {
        print("sendMessage called with text: \(userMessage)")
        let userMsg = Message(text: userMessage, isUserMessage: true)
        messages.append(userMsg)
        userMessage = ""

        apiService.sendMessage(userMsg.text, model: selectedModel) { [weak self] (result: Result<String, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseText):
                    print("API response: \(responseText)")
                    let botMsg = Message(text: responseText, isUserMessage: false)
                    self?.messages.append(botMsg)
                case .failure(let error):
                    print("Error sending message: \(error)")
                }
            }
        }
    }
}
