//
//  IntelligenceRequest.swift
//  StudyBuddy
//
//  Created by Gustavo Garfias on 10/02/2025.
//

import Foundation

protocol IntelligenceRequest {
    var input: String { get set }
    var model: IntelligenceModel { get set }
}
