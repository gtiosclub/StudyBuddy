//
//  OpenAIRequest.swift
//  StudyBuddy
//
//  Created by Hans Ibarra on 2/12/25.
//

import Foundation

struct OpenAIRequest: Codable, IntelligenceRequest {
    var input: String
    var model: IntelligenceModel
    
    let messages: [Message]
    let maxCompletionTokens: Int?
    let temperature: Double?

    enum CodingKeys: String, CodingKey {
        case input, model, messages, temperature
        case maxCompletionTokens = "max_completion_tokens"
    }

    struct Message: Codable {
        let role: String
        let content: String
    }
}
