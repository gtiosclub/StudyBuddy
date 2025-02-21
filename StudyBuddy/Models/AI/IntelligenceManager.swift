//
//  IntelligenceManager.swift
//  StudyBuddy
//
//  Created by Gustavo Garfias on 11/02/2025.
//

import Foundation


protocol IntelligenceManager {
    func makeRequest(_ req: IntelligenceRequest) async throws -> IntelligenceResponse
}
