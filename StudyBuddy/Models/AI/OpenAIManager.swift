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
}

struct OpenAIIntelligenceResponse: IntelligenceResponse {
    var output: String
}
