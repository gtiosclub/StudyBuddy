//
//  LlamaManager.swift
//  StudyBuddy
//
//  Created by Gustavo Garfias on 20/02/2025.
//

import Foundation

struct LlamaIntelligenceRequest: IntelligenceRequest {
    var input: String
    var model: IntelligenceModel
}

struct LlamaIntelligenceResponse: IntelligenceResponse {
    var output: String
}

class LlamaIntelligenceManager: IntelligenceManager {
    func makeRequest(_ req: IntelligenceRequest) async throws -> IntelligenceResponse {
        let response = LlamaIntelligenceResponse(output: "Processed: \(req.input) using model \(req.model)")
        return response
    }
}
