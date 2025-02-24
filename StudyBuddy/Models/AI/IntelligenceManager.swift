import Foundation

protocol IntelligenceManager {
    func makeRequest(_ req: IntelligenceRequest) async throws -> IntelligenceResponse
}
