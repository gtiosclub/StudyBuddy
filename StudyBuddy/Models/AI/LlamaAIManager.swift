//
//  LlamaAIManager.swift
//  StudyBuddy
//
//  Created by Matthew Dong on 2/11/25.
//

import Foundation
import SwiftUI
import MLXLMCommon

struct LLMRequest {
    var prompt: String
    var continuous: Bool
    var systemPrompt: String
    var maxCharacters: Int?
}

struct LLMResponse {
    var output: String
    var trimmedresponse: Bool
}

struct LlamaResponse: IntelligenceResponse {
    var output: String
}

@MainActor
class LlamaAIManager: IntelligenceManager {
     static let shared = LlamaAIManager()
     
     private let llama = LLMEvaluator()
     private var thread = Thread()

     private init() {}

     func makeRequest(_ req: IntelligenceRequest) async throws -> IntelligenceResponse {
         thread.messages.append(.init(role: .user, content: req.input))
         let response = await llama.generate(
            modelName: ModelConfiguration.llama_3_2_1b_4bit.name,
            thread: thread,
            systemPrompt: "You are a helpful assistant. You need to provide a response to the user's question.")
         
         return LlamaResponse(output: response)
     }
 }
