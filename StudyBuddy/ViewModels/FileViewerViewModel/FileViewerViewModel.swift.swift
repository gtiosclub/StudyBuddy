//
//  FileViewerViewModel.swift.swift
//  StudyBuddy
//
//  Created by alina on 2025/3/3.
//

import Foundation
import SwiftUI

class FileViewerViewModel: ObservableObject {
    @Published var files: [FileModel] = [] // file names

    init() {
        /// Load or initialize files here
        files = [
            FileModel(name: "Document1.pdf", size: 1024, createdAt: Date()),
            FileModel(name: "Image.png", size: 2048, createdAt: Date()),
            FileModel(name: "Report.docx", size: 512, createdAt: Date())
        ]
    }
}
