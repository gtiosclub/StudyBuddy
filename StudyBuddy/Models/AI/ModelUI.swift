//
//  ModelUI.swift
//  StudyBuddy
//
//  Created by Aryan Patel on 3/4/25.
//
import SwiftUI

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct ChatInterfaceView: View {
    @State private var messages: [ChatMessage] = []
    @State private var inputText: String = ""
    @State private var selectedModel: String = "OpenAI"
    let models = ["OpenAI", "LLaMA (On-Device)"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Model Picker
            Picker("AI Model", selection: $selectedModel) {
                ForEach(models, id: \ .self) { model in
                    Text(model).tag(model)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            
            // Chat History
            ScrollViewReader { scrollView in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(messages) { message in
                            ChatBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .background(Color(UIColor.systemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .frame(maxHeight: .infinity)
            
            // Improved Input Field
            HStack(spacing: 10) {
                TextField("Type a message...", text: $inputText)
                    .padding(14)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(UIColor.systemGray6)))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.leading, 10)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(14)
                        .background(Circle().fill(Color.blue))
                        .shadow(radius: 4)
                }
                .padding(.trailing, 10)
            }
            .padding(.vertical, 8)
            .background(Color(UIColor.systemBackground).shadow(radius: 2))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func sendMessage() {
        guard !inputText.isEmpty else { return }
        let userMessage = ChatMessage(text: inputText, isUser: true)
        messages.append(userMessage)
        inputText = ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let aiMessage = ChatMessage(text: "Response from \(selectedModel)", isUser: false)
            messages.append(aiMessage)
        }
    }
}

struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.text)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(radius: 2)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: .trailing)
            } else {
                Text(message.text)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(16)
                    .shadow(radius: 2)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: .leading)
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

struct ChatInterfaceView_Previews: PreviewProvider {
    static var previews: some View {
        ChatInterfaceView()
    }
}

