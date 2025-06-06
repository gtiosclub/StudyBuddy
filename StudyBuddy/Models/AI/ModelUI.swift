//
//  ModelUI.swift
//  StudyBuddy
//
//  Created by Aryan Patel on 3/4/25.
//
import SwiftUI
import MLXLMCommon
import Firebase
import FirebaseFirestore

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct ChatInterfaceView: View {
    @Environment(\.modelContext) var modelContext

    @State var messages: [ChatMessage] = []
    var set: StudySetModel?

    @State private var inputText: String = ""
    @State private var selectedModel: String = "OpenAI"
    let models = ["OpenAI", "LLaMA (On-Device)"]

    @State private var llm = LLMEvaluator()
    @State private var thread = Thread()

    @State private var intelligenceManager: IntelligenceManager = OpenAIManager.shared

    @State var currentThread: Thread?
    @State var thinkingTime: TimeInterval?

    @State private var generatingThreadID: UUID?
    private let db = Firestore.firestore()
    @State private var documentsContent: [String] = []
//    @Environment(LLMEvaluator.self) var llm

    var body: some View {
        ZStack {
            Color(hex: "#321C58").edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                // Model Picker
                Picker("AI Model", selection: $selectedModel) {
                    ForEach(models, id: \ .self) { model in
                        Text(model).tag(model)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(Color.lightPurple.opacity(0.2))
                .tint(.purple)
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
                    .background(Color(hex: "#321C58"))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .frame(maxHeight: .infinity)

                // Improved Input Field
                HStack(spacing: 10) {
                    
                    TextField("Type a message...", text: $inputText)
                        .padding(14)
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color(hex: "#432A6E")))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(hex: "#432A6E").opacity(0.3), lineWidth: 1)
                        )
                        .padding(.leading, 10)

                    Button(action: {
                        Task {
                            do {
                                try await sendMessage()
                            } catch {
                                print("Error sending message: \(error)")
                            }
                        }
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(14)
                            .background(Circle().fill(Color("cardColor")))
                            .shadow(radius: 4)
                    }
                    .padding(.trailing, 10)
                }
                .padding(.vertical, 8)
            }
            .task {
                await getDocuments()
                print("Document fetching completed!")
            }
        }
    }

    func sendMessage() async throws {
        guard !inputText.isEmpty else { return }
        let userMessage = ChatMessage(text: inputText, isUser: true)
        messages.append(userMessage)
        inputText = ""

        switch selectedModel {
        case "OpenAI":
            let openAIManager = OpenAIManager.shared
            
            let contentsAsMessages: [OpenAIRequest.Message] = documentsContent.map { content in
                .init(role: "user", content: content)
            }
            
            let fullContext: [OpenAIRequest.Message] = contentsAsMessages + messages.map { msg in
                .init(role: msg.isUser ? "user" : "assistant", content: msg.text)
            }
            
            let req = OpenAIRequest(
                input: userMessage.text,
                model: .openai_4o_mini,
                messages: fullContext,
                maxCompletionTokens: nil,
                temperature: 0.8
            )

            let response = try await openAIManager.makeRequest(req)

            let aiMessage = ChatMessage(text: response.output, isUser: false)
            messages.append(aiMessage)

        case "LLaMA (On-Device)":
            let llamaManager = LlamaAIManager.shared
            let req = LlamaIntelligenceRequest(input: userMessage.text, model: .llama_3_2_1b)

//            let response = await llama.generate(modelName: ModelConfiguration.llama_3_2_1b_4bit.name, thread: thread, systemPrompt: inputText)
//            let aiMessage = ChatMessage(text: response, isUser: false)
            let response = try await llamaManager.makeRequest(req)

            let aiMessage = ChatMessage(text: response.output, isUser: false)
            messages.append(aiMessage)

//            let response = try await llamaManager.makeRequest(req)
        default:
            break
        }
        
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            let aiMessage = ChatMessage(text: "Response from \(selectedModel)", isUser: false)
//            messages.append(aiMessage)
//        }
    }
    
    private func generate(prompt: String) async {
        if currentThread == nil {
            let newThread = Thread()
            currentThread = newThread
            modelContext.insert(newThread)
            try? modelContext.save()
        }

        if let currentThread = currentThread {
            generatingThreadID = currentThread.id
            Task {
                let message = prompt
//                prompt = ""
//                appManager.playHaptic()
                sendMessage(Message(role: .user, content: message, thread: currentThread))
//                isPromptFocused = true
                let modelName = ModelConfiguration.llama_3_2_1b_4bit.name
                let output = await llm.generate(modelName: modelName, thread: currentThread, systemPrompt: "You are a helpful assistant. You need to provide a response to the user's question.")
                sendMessage(Message(role: .assistant, content: output, thread: currentThread, generatingTime: llm.thinkingTime))
                generatingThreadID = nil
            }
        }
    }

    private func sendMessage(_ message: Message) {
        modelContext.insert(message)
        try? modelContext.save()
        
        let aiMessage = ChatMessage(text: message.content, isUser: false)
        messages.append(aiMessage)
    }
    
    private func getDocuments() async {
        var contents: [String] = []

        guard let set else { return } // no set passed in as context...
        let docs = set.documentIDs

        for docID in docs {
            let docRef = db.collection("Documents").document(docID)
            do {
                let document = try await docRef.getDocument(as: Document.self)
                let content = document.parsedContent

                guard let content else {
                    print("Error: Content is nil")
                    continue
                }

                contents.append(content)
            } catch {
                print("Error fetching document: \(error)")
                continue
            }
        }
        
        documentsContent.append(contentsOf: contents)
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
                    .background(Color("cardColor"))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(radius: 2)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: .trailing)
            } else {
                Text(message.text)
                    .padding()
                    .background(Color("calvinColor").opacity(0.3))
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
