//
//  OpenAIRequest.swift
//  StudyBuddy
//
//  Created by Hans Ibarra on 2/12/25.
//

import Foundation

struct OpenAIRequest: Encodable, IntelligenceRequest {
    var input: String
    var model: IntelligenceModel
    let messages: [Message]
    let maxCompletionTokens: Int?
    let temperature: Double?
    var responseFormat: ResponseFormat?

    enum CodingKeys: String, CodingKey {
        case model, messages, temperature
        case maxCompletionTokens = "max_completion_tokens"
        case responseFormat = "response_format"
    }

    struct Message: Codable {
        let role: String
        let content: String
    }

    static let flashcardResponseFormatStruct: ResponseFormat = .init(
        type: "json_schema",
        jsonSchema: .init(
            name: "flashcards",
            strict: true,
            schema: .init(
                type: "object",
                properties: .init(
                    flashcards: .init(
                        type: "array",
                        items: .init(
                            type: "object",
                            properties: .init(
                                question: .init(type: "string"),
                                answer: .init(type: "string")),
                            required: [
                                "question",
                                "answer"
                            ],
                            additionalProperties: false
                        )
                    )
                ),
                required: [
                    "flashcards"
                ],
                additionalProperties: false
            )
        )
    )

    struct ResponseFormat: Encodable {
        let type: String
        let jsonSchema: JsonSchema

        enum CodingKeys: String, CodingKey {
            case type
            case jsonSchema = "json_schema"
        }

        struct JsonSchema: Encodable {
            let name: String
            let strict: Bool
            let schema: Schema

            struct Schema: Encodable {
                let type: String
                let properties: Properties
                let required: [String]
                let additionalProperties: Bool

                struct Properties: Encodable {
                    let flashcards: Flashcards

                    struct Flashcards: Encodable {
                        let type: String
                        let items: Item

                        struct Item: Encodable {
                            let type: String
                            let properties: Properties
                            let required: [String]
                            let additionalProperties: Bool

                            struct Properties: Encodable {
                                let question: Question
                                let answer: Answer

                                struct Question: Encodable {
                                    let type: String
                                }

                                struct Answer: Encodable {
                                    let type: String
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
