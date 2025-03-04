//
//  DocumentPickerView.swift
//  StudyBuddy
//
//  Created by alina on 2025/2/12.
//

import SwiftUI
import UniformTypeIdentifiers
import UIKit

struct DocumentPickerView: UIViewControllerRepresentable {
    @ObservedObject var uploadViewModel: UploadViewModel

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        // Create a document picker that only allows users to select PDF files
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = true // Enable multiple file selection
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPickerView

        init(_ parent: DocumentPickerView) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            for url in urls {
                // Create initial document with just the filename - content will be added after parsing
                let document = Document(fileName: url.lastPathComponent, content: "")
                
                // Process the PDF and extract text
                extractTextFromPDF(pdfURL: url, document: document) { extractedText, updatedDocument in
                    DispatchQueue.main.async {
                        // Update view model with the document names
                        if !self.parent.uploadViewModel.selectedDocumentNames.contains(url.lastPathComponent) {
                            self.parent.uploadViewModel.selectedDocumentNames.append(url.lastPathComponent)
                        }
                        
                        // Save document to Firebase
                        self.parent.uploadViewModel.saveDocumentToFirebase(updatedDocument)
                    }
                }
            }
        }
    }
}
