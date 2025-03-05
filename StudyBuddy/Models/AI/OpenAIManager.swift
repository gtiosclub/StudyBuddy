import Foundation
import OpenAIKit

final class OpenAIManager: IntelligenceManager {

    static let shared = OpenAIManager()

    private init() {}

    static let apiKey = "KEY"
    private let baseURL = URL(string: "https://api.openai.com/v1/chat/completions")!

    func makeRequest(_ req: IntelligenceRequest) async throws -> IntelligenceResponse {

        let requestData = OpenAIRequest(
            input: req.input,
            model: .openai_4o_mini,
            messages: [
                .init(role: "user", content: req.input)
            ],
            maxCompletionTokens: 150,
            temperature: 0.7
        )
        
        

        
        
        let jsonString = """
        {
            "model": "gpt-4o-mini",
            "messages": [
                { "role": "system", "content": "You are a helpful assistant." },
                {
                    "role": "user",
                    "content": "\(req.input)"
                }
            ]
        }
        """
        
        let simple = SimpleRequest(
            model: "gpt-4o-mini",
            messages: [
                SimpleRequest.Message(role: "system", content: "You are a helpful assistant"),
                SimpleRequest.Message(role: "user", content: req.input)
            ]
        )
        
        let jsonData = try JSONEncoder().encode(simple)

        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(OpenAIManager.apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let (data, response) = try await URLSession.shared.data(for: request)
        
        print(data)
        print(response)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "Invalid server response", code: -1, userInfo: nil)
        }

        let decodedResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)

        guard let output = decodedResponse.choices.first?.message.content else {
            throw NSError(domain: "Invalid server response, no message received", code: -1, userInfo: nil)
        }

        return OpenAIIntelligenceResponse(output: output)
    }
    
    struct SimpleRequest: Codable {
        var model: String
        var messages: [Message]
        
        struct Message: Codable {
            var role: String
            var content: String
        }
    }
}

struct OpenAIIntelligenceResponse: IntelligenceResponse {
    var output: String
}
