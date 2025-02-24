import Foundation

final class OpenAIManager: IntelligenceManager {

    static let shared = OpenAIManager()

    private init() {}

    private let apiKey = "your-openai-api-key"
    private let baseURL = URL(string: "https://api.openai.com/v1/completions")!

    func makeRequest(_ req: IntelligenceRequest) async throws -> IntelligenceResponse {

        let requestData = OpenAIRequest(
            model: "gpt-4o-mini",
            messages: [
                .init(role: "user", content: req.input)
            ],
            maxCompletionTokens: 150,
            temperature: 0.7
        )

        let jsonData = try JSONEncoder().encode(requestData)

        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
