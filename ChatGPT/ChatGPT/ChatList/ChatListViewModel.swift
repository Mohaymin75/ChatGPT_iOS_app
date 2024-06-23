// ChatListViewModel.swift
// ConvoTrack
//
// Created by Mohaymin Islam on 2024-06-19.
//

import SwiftUI
import CoreData

enum LoadingState {
    case loading
    case noResults
    case resultFound
}

class ChatListViewModel: ObservableObject {
    @Published var chats: [AppChat] = []
    @Published var searchText: String = ""
    @Published var loadingState: LoadingState = .loading
    
    private let managedObjectContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
    }
    
    func loadData() {
        let fetchRequest: NSFetchRequest<ChatEntity> = ChatEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastMessageSent", ascending: false)]
        
        do {
            let chatEntities = try managedObjectContext.fetch(fetchRequest)
            self.chats = chatEntities.map { entity in
                AppChat(id: entity.id!,
                        topic: entity.topic,
                        model: ChatModel(rawValue: entity.model ?? ""),
                        lastMessageSent: entity.lastMessageSent!,
                        owner: entity.owner!)
            }
            loadingState = chats.isEmpty ? .noResults : .resultFound
        } catch {
            print("Failed to fetch chats: \(error)")
            loadingState = .noResults
        }
    }
    
    func startNewChat() {
        let newChat = ChatEntity(context: managedObjectContext)
        newChat.id = UUID().uuidString
        newChat.topic = "New Chat"
        newChat.model = ChatModel.gpt3_5_turbo.rawValue
        newChat.lastMessageSent = Date()
        newChat.owner = "CurrentUser" // Replace with actual user ID when implemented
        
        do {
            try managedObjectContext.save()
            loadData()
        } catch {
            print("Failed to create new chat: \(error)")
        }
    }
    
    func deleteChat(at offsets: IndexSet) {
        for index in offsets {
            let chat = chats[index]
            let fetchRequest: NSFetchRequest<ChatEntity> = ChatEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", chat.id)
            
            do {
                let results = try managedObjectContext.fetch(fetchRequest)
                for entity in results {
                    managedObjectContext.delete(entity)
                }
                try managedObjectContext.save()
                chats.remove(at: index)
            } catch {
                print("Failed to delete chat: \(error)")
            }
        }
    }
    
    func renameChat(chatId: String, newName: String) {
        let fetchRequest: NSFetchRequest<ChatEntity> = ChatEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", chatId)
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            if let chatEntity = results.first {
                chatEntity.topic = newName
                try managedObjectContext.save()
                loadData()
            }
        } catch {
            print("Failed to rename chat: \(error)")
        }
    }
    
    func searchChats() -> [AppChat] {
        if searchText.isEmpty {
            return chats
        } else {
            return chats.filter { chat in
                chat.topic?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
    }
}
