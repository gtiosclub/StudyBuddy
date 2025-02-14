import Foundation

protocol IntelligenceManager {
    // Remove this version
    func sendRequest(prompt: String, completion: @escaping (Result<String, Error>) -> Void)
    
    // this was the original version; let's keep it
    func makeRequest(_ req: IntelligenceRequest) async throws -> IntelligenceResponse
}

final class OpenAIManager: IntelligenceManager {
    
    // you should move your logic here
    func makeRequest(_ req: any IntelligenceRequest) async throws -> any IntelligenceResponse {
        throw NSError(domain: "OpenAIManager", code: 1)
    }
    
    
    static let shared = OpenAIManager()
    
    private init() {}
    
    private let apiKey = "your-openai-api-key"
    
    private let baseURL = URL(string: "https://api.openai.com/v1/completions")!
    
    private let session = URLSession.shared
    
    // this method should be removed
    func sendRequest(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        let requestBody: [String: Any] = [
            "model": "gpt-4o-2024-08-06", // Specify the model
            "prompt": prompt,
            "max_tokens": 150,
            "temperature": 0.7
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(.failure(NSError(domain: "Invalid JSON", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let text = choices.first?["text"] as? String {
                    completion(.success(text))
                } else {
                    completion(.failure(NSError(domain: "Invalid response format", code: -1, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
