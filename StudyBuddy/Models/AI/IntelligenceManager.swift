//
//  IntelligenceManager.swift
//  StudyBuddy
//
//  Created by Gustavo Garfias on 11/02/2025.
//

import Foundation


protocol IntelligenceManager {
    func makeRequest(_ req: IntelligenceRequest) async throws -> IntelligenceResponse
}

struct AIIntelligenceRequest: IntelligenceRequest {
    var input: String
    var model: IntelligenceModel
}

struct AIIntelligenceResponse: IntelligenceResponse {
    var output: String
}

class AIIntelligenceManager: IntelligenceManager {
    func makeRequest(_ req: IntelligenceRequest) async throws -> IntelligenceResponse {
        let response = AIIntelligenceResponse(output: "Processed: \(req.input) using model \(req.model)")
        return response
    }
}
