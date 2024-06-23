//
//  ChatDetailView.swift
//  ConvoTrack
//
//  Created by Mohaymin Islam on 2024-06-19.
//



import SwiftUI

struct ChatDetailView: View {
    @ObservedObject var viewModel: ChatDetailViewModel
    @State private var selectedModel: ChatModel
    
    init(viewModel: ChatDetailViewModel) {
        self.viewModel = viewModel
        self._selectedModel = State(initialValue: viewModel.selectedModel)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    selectedModel = .gpt3_5_turbo
                    viewModel.selectedModel = .gpt3_5_turbo
                }) {
                    Text(ChatModel.gpt3_5_turbo.rawValue)
                        .foregroundColor(selectedModel == .gpt3_5_turbo ? .white : .green)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedModel == .gpt3_5_turbo ? Color.green : Color.clear)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    selectedModel = .gpt4
                    viewModel.selectedModel = .gpt4
                }) {
                    Text(ChatModel.gpt4.rawValue)
                        .foregroundColor(selectedModel == .gpt4 ? .white : .purple)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedModel == .gpt4 ? Color.purple : Color.clear)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            HStack {
                                if message.isUserMessage {
                                    Spacer()
                                    Text(message.text)
                                        .padding()
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(8)
                                        .foregroundColor(.blue)
                                        .id(message.id)
                                } else {
                                    Text(message.text)
                                        .padding()
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(8)
                                        .foregroundColor(.gray)
                                        .id(message.id)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages) { _ in
                    if let lastMessage = viewModel.messages.last {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
            
            HStack {
                TextField("Type your message...", text: $viewModel.userMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }
            }
            .padding()
        }
        .navigationTitle("New Chat")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
    }
}
