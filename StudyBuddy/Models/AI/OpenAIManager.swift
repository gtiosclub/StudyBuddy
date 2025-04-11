import Foundation

final class OpenAIManager: IntelligenceManager {

    static let shared = OpenAIManager()

    private init() {}

    private let baseURL = URL(string: "https://api.openai.com/v1/chat/completions")!

    func makeRequest(_ req: IntelligenceRequest) async throws -> IntelligenceResponse {
        var requestData: OpenAIRequest

        if let openAIRequest = req as? OpenAIRequest {
            requestData = openAIRequest
        } else {
            requestData = OpenAIRequest(
                input: req.input,
                model: .openai_4o_mini,
                messages: [
                    .init(role: "system", content: "You are a helpful assistant."),
                    .init(role: "user", content: req.input)
                ],
                maxCompletionTokens: 150,
                temperature: 0.7
            )
        }
        
        let jsonData = try JSONEncoder().encode(requestData)
//        if let jsonString = String(data: jsonData, encoding: .utf8) {
//            print(jsonString)
//        }

        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.addValue("""
        KEY
        """, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "Invalid server response", code: -1, userInfo: nil)
        }

        let decodedResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)

        guard let output = decodedResponse.choices.first?.message.content else {
            throw NSError(domain: "Invalid server response, no message received", code: -1, userInfo: nil)
        }

        return OpenAIIntelligenceResponse(output: output)
    }

    // swiftlint:disable:next function_body_length
    func makeFlashcards(content: [String]) async throws -> [(String, String)] {
        var messages: [OpenAIRequest.Message] = [
            .init(role: "system", content: """
            Your task is condensing the information from all the source documents and identifying key concepts that a student would need to learn for an exam. 
            The end goal is creating flashcards for each of the key concepts.
            Each flashcard should have a question and an answer.
            """)
        ]

        for document in content {
            messages.append(.init(role: "user", content: document))
        }

        let flashcardRequest = OpenAIRequest(
            input: "",
            model: .openai_4o_mini,
            messages: messages,
            maxCompletionTokens: 1000,
            temperature: 0.7,
            responseFormat: OpenAIRequest.flashcardResponseFormatStruct
        )

        let response = try await self.makeRequest(flashcardRequest)

        let flashcardResponse =
        try JSONDecoder()
            .decode(
                OpenAIFlashcardResponse.self,
                from: response.output.data(using: .utf8)!
            )

        let flashcards = flashcardResponse.flashcards.map { ($0.question, $0.answer) }

        return flashcards
    }
}

struct OpenAIIntelligenceResponse: IntelligenceResponse {
    var output: String
}

struct OpenAIFlashcardResponse: Decodable {
    let flashcards: [OpenAIFlashcard]
}

struct OpenAIFlashcard: Decodable {
    let question: String
    let answer: String
}
