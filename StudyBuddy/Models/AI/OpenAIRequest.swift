//
//  OpenAIRequest.swift
//  StudyBuddy
//
//  Created by Hans Ibarra on 2/12/25.
//

import Foundation

struct OpenAIRequest: Codable {
    let model: String
    let messages: [Message]
    let maxCompletionTokens: Int?
    let temperature: Double?

    enum CodingKeys: String, CodingKey {
        case model, messages, temperature
        case maxCompletionTokens = "max_completion_tokens"
    }

    struct Message: Codable {
        let role: String
        let content: String
    }
}
