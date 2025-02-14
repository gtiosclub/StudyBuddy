//
//  LlamaAIManager.swift
//  StudyBuddy
//
//  Created by Matthew Dong on 2/11/25.
//

import Foundation

struct LlamaResponse: IntelligenceResponse {
    var output: String
}

class LlamaAIManager: IntelligenceManager {
    func sendRequest(prompt: String, completion: @escaping (Result<String, any Error>) -> Void) {
        print("TODO")
    }
    
    static let shared = LlamaAIManager()

    private init() {}

    func makeRequest(_ req: IntelligenceRequest) async throws -> IntelligenceResponse {
        // TODO: Implement feature
        throw NSError(domain: "missing method", code: 1)
    }
}
