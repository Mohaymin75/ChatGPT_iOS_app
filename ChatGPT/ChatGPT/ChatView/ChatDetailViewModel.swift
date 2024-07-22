//
//  ChatDetailViewModel.swift
//  ConvoTrack
//
//  Created by Mohaymin Islam on 2024-06-19.
//

import SwiftUI
import CoreData

class ChatDetailViewModel: ObservableObject {
    @Published var chat: AppChat
    @Published var messages: [ChatMessage] = []
    @Published var userMessage: String = ""
    @Published var selectedModel: ChatModel
    private let managedObjectContext: NSManagedObjectContext
    private let apiService = OpenAIAPIService()
    
    init(chat: AppChat, context: NSManagedObjectContext) {
        self.chat = chat
        self.selectedModel = chat.model ?? .gpt3_5_turbo
        self.managedObjectContext = context
        loadMessages()
    }
    
    private func loadMessages() {
        let fetchRequest: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "chat.id == %@", chat.id)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        do {
            let messageEntities = try managedObjectContext.fetch(fetchRequest)
            self.messages = messageEntities.map { entity in
                ChatMessage(id: entity.id!, text: entity.text!, isUserMessage: entity.isUserMessage, timestamp: entity.timestamp!)
            }
        } catch {
            print("Failed to fetch messages: \(error)")
        }
    }
    
    func sendMessage() {
        guard !userMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newMessage = ChatMessage(id: UUID().uuidString, text: userMessage, isUserMessage: true, timestamp: Date())
        saveMessage(newMessage)
        userMessage = ""
        
        apiService.sendMessage(newMessage.text, model: selectedModel) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseText):
                    let botMessage = ChatMessage(id: UUID().uuidString, text: responseText, isUserMessage: false, timestamp: Date())
                    self?.saveMessage(botMessage)
                case .failure(let error):
                    print("Error sending message: \(error)")
                }
            }
        }
    }
    
    func regenerateResponse(for message: ChatMessage) {
            guard !message.isUserMessage else { return }
            
            // Find the user message that triggered this response
            if let index = messages.firstIndex(where: { $0.id == message.id }),
               index > 0,
               messages[index - 1].isUserMessage {
                let userMessage = messages[index - 1].text
                
                // Remove the old AI response
                messages.remove(at: index)
                
                // Call the API to get a new response
                apiService.sendMessage(userMessage, model: selectedModel) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let responseText):
                            let newBotMessage = ChatMessage(id: UUID().uuidString, text: responseText, isUserMessage: false, timestamp: Date())
                            self?.saveMessage(newBotMessage)
                        case .failure(let error):
                            print("Error regenerating message: \(error)")
                        }
                    }
                }
            }
        }
    
    private func saveMessage(_ message: ChatMessage) {
        let entity = MessageEntity(context: managedObjectContext)
        entity.id = message.id
        entity.text = message.text
        entity.isUserMessage = message.isUserMessage
        entity.timestamp = message.timestamp
        
        let fetchRequest: NSFetchRequest<ChatEntity> = ChatEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", chat.id)
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            if let chatEntity = results.first {
                entity.chat = chatEntity
                chatEntity.lastMessageSent = message.timestamp
            } else {
                let chatEntity = ChatEntity(context: managedObjectContext)
                chatEntity.id = chat.id
                chatEntity.topic = chat.topic
                chatEntity.model = chat.model?.rawValue
                chatEntity.lastMessageSent = message.timestamp
                chatEntity.owner = chat.owner
                entity.chat = chatEntity
            }
            
            try managedObjectContext.save()
            self.messages.append(message)
        } catch {
            print("Failed to save message: \(error)")
        }
    }
    
}
