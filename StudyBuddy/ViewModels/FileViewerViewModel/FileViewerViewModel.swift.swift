//
//  FileViewerViewModel.swift.swift
//  StudyBuddy
//
//  Created by alina on 2025/3/3.
//

import Foundation
import SwiftUI

class FileViewerViewModel: ObservableObject {
    @Published var files: [Document] = [] // Array of DocumentsModel objects

    init() {
        // Load or initialize files here
        files = [
            Document(fileName: "Document1.pdf", content: "This is the content of Document 1"),
            Document(fileName: "Image.png", content: "This is the content of Image"),
            Document(fileName: "Report.docx", content: "This is the content of Report")
        ]
    }
}
