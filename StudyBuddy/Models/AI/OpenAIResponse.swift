//
//  OpenAIResponse.swift
//  StudyBuddy
//
//  Created by Hans Ibarra on 2/12/25.
//

struct OpenAIResponse: Codable {
    let choices: [Choice]
}

extension OpenAIResponse {
    struct Choice: Codable {
        let message: Message
    }

    struct Message: Codable {
        let content: String
    }
}
