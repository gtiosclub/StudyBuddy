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
        // Only PDF selection
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = true
        picker.overrideUserInterfaceStyle = .dark // Optional: force dark mode to match theme
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
                    let isAccessing = url.startAccessingSecurityScopedResource()
                    let fileData = try Data(contentsOf: url)
                    if isAccessing {
                        url.stopAccessingSecurityScopedResource()
                    }
                    guard let userID = Auth.auth().getUserID() else {
                        print("Error in DocumentPickerView: couldn't retrieve userID")
                        return
                    }

                    var document = Document(
                        fileName: url.lastPathComponent,
                        content: "",
                        fileData: fileData,
                        userID: userID,
                        isPrivate: false
                    )

                    extractTextFromPDF(pdfURL: url, document: document) { extractedText, updatedDocument in
                        DispatchQueue.main.async {
                            var finalDocument = updatedDocument
                            finalDocument.updateParsedContent(extractedText)

                            if !self.parent.uploadViewModel.selectedDocumentNames.contains(url.lastPathComponent) {
                                self.parent.uploadViewModel.selectedDocumentNames.append(url.lastPathComponent)
                            }

                            self.parent.uploadViewModel.documents.append(finalDocument)
                        }
                    }
                } catch {
                    print("Error reading file data: \(error)")
                }
            }
            print("Documents added to upload queue")
            // Dismiss the document picker
            self.parent.presentationMode.wrappedValue.dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.parent.uploadViewModel.isUploadPresented = true // Trigger UploadView
            }
        }
    }
}
