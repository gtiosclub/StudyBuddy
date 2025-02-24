import Foundation


protocol IntelligenceManager {
    func makeRequest(_ req: IntelligenceRequest) async throws -> IntelligenceResponse
}

// final class OpenAIManager: IntelligenceManager {

//     static let shared = OpenAIManager()

//     private init() {}

//     private let apiKey = "your-openai-api-key"

//     private let baseURL = URL(string: "https://api.openai.com/v1/completions")!

//     private let session = URLSession.shared

//     func makeRequest(_ req: IntelligenceRequest) async throws -> IntelligenceResponse {
//         throw NSError(domain: "missing method", code: 1)
//     }

//     func sendRequest(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
//         let requestBody: [String: Any] = [
//             "model": "text-davinci-003", // Specify the model
//             "prompt": prompt,
//             "max_tokens": 150,
//             "temperature": 0.7
//         ]

//         guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
//             completion(.failure(NSError(domain: "Invalid JSON", code: -1, userInfo: nil)))
//             return
//         }

//         var request = URLRequest(url: baseURL)
//         request.httpMethod = "POST"
//         request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//         request.httpBody = jsonData

//         let task = session.dataTask(with: request) { data, _, error in
//             if let error = error {
//                 completion(.failure(error))
//                 return
//             }

//             guard let data = data else {
//                 completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
//                 return
//             }

//             do {
//                 if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                    let choices = json["choices"] as? [[String: Any]],
//                    let text = choices.first?["text"] as? String {
//                     completion(.success(text))
//                 } else {
//                     completion(.failure(NSError(domain: "Invalid response format", code: -1, userInfo: nil)))
//                 }
//             } catch {
//                 completion(.failure(error))
//             }
//         }

//         task.resume()
//     }
// }
