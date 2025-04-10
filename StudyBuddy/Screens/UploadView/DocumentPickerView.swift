//
//  DocumentPickerView.swift
//  StudyBuddy
//
//  Created by alina on 2025/2/12.
//

import SwiftUI
import UniformTypeIdentifiers
import UIKit
import FirebaseAuth

struct DocumentPickerView: UIViewControllerRepresentable {
    @ObservedObject var uploadViewModel: UploadViewModel
    @Environment(\.presentationMode) var presentationMode
    
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
                do {
                    // read file data
                    let fileData = try Data(contentsOf: url)
                    guard let userID = Auth.auth().getUserID() else {
                        print("Error found in DocumentPickerView getting userID")
                        return
                    }
                    // Extract text content from the PDF
                    var document = Document(fileName: url.lastPathComponent, content: "", fileData: fileData, userID: userID, isPrivate: false)
                    extractTextFromPDF(pdfURL: url, document: document) { extractedText, updatedDocument in
                        DispatchQueue.main.async {
                            // Update the document content
                            var finalDocument = updatedDocument
                            finalDocument.updateParsedContent(extractedText)

                            // Add the document to the view model's documents list
                            if !self.parent.uploadViewModel.selectedDocumentNames.contains(url.lastPathComponent) {
                                self.parent.uploadViewModel.selectedDocumentNames.append(url.lastPathComponent)
                            }
                            self.parent.uploadViewModel.selectedDocuments.append(finalDocument)

                        }
                    }
                } catch {
                    print("Error reading file data: \(error)")
                }
            }
            print("DocumentUploaded sucessfully")
            // Dismiss the document picker and present the upload view
            self.parent.presentationMode.wrappedValue.dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.parent.uploadViewModel.isUploadPresented = true
            }
        }
    }
}
