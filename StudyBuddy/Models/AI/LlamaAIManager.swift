//
//  LlamaAIManager.swift
//  StudyBuddy
//
//  Created by Matthew Dong on 2/11/25.
//

import Foundation


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

class LlamaAIManager: IntelligenceManager {
    static let shared = LlamaAIManager()

    private init() {}
    
    func sendRequest(prompt: String, completion: @escaping (Result<String, any Error>) -> Void) {
        
    }

    func makeRequest(_ req: IntelligenceRequest) async throws -> IntelligenceResponse {
 
        // TODO: Implement feature
        throw NSError(domain: "missing method", code: 1)
    }
}
