//
//  UploadViewModel.swift
//  StudyBuddy
//
//  Created by Tony Nguyen on 2/11/25.
//

import Foundation
import SwiftUI

class UploadViewModel: ObservableObject {
    @Published var extractedText: [String] = []
    @Published var isProcessing = false
    @Published var error: TextRecognizer.ExtractionError?
    
    private let textRecognizer = TextRecognizer()
    
    func processDocument(at url: URL) {
        isProcessing = true
        
        textRecognizer.extractText(from: url) { [weak self] result in
            DispatchQueue.main.async {
                self?.isProcessing = false
                
                switch result {
                case .success(let texts):
                    self?.extractedText = texts
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
}
