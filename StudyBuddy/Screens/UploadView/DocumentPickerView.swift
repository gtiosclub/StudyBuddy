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
            // Extract the names of the selected documents
            let selectedDocuments = urls.map { $0.lastPathComponent }
            DispatchQueue.main.async {
                // Update the view model with the selected document names
                self.parent.uploadViewModel.selectedDocumentNames = selectedDocuments
            }
        }
    }
}
