//
//  UploadView.swift
//  StudyBuddy
//
//  Created by Tony Nguyen on 2/11/25.
//

import SwiftUI

struct UploadView: View {
    // ViewModel to manage uploaded documents
    @StateObject var uploadViewModel = UploadViewModel()
    // State variable to control the upload file visibility
    @State private var isPublic = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Upload Document")
                .font(.headline)
                .padding()

            if !uploadViewModel.selectedDocumentNames.isEmpty {
                VStack(alignment: .leading) {
                    Text("Selected Documents:")
                        .font(.headline)
                    ForEach(uploadViewModel.selectedDocumentNames, id: \.self) { document in
                        Text(document)
                            .padding(5)
                    }
                }
                .padding()
            }

            HStack {
                Text("Private")
                    .foregroundColor(.blue)
                    .bold()
                Toggle("", isOn: $isPublic)
                    .toggleStyle(SwitchToggleStyle(tint: .green))
                    .labelsHidden()
                Text("Public")
                    .foregroundColor(.green)
                    .bold()
            }
            .padding()

            Button(action: {
                // Handle upload action
                for document in uploadViewModel.documents {
                    uploadViewModel.saveDocumentToFirebase(document, isPublic: isPublic)
                }
                // Close view and toggle flags
                presentationMode.wrappedValue.dismiss()
                uploadViewModel.isUploadPresented = false
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Upload Files")
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(isPublic ? .green : .blue)
            .bold()
        }
        .padding()
        .frame(maxWidth: 300)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
    }
}

#Preview {
    UploadView(uploadViewModel: UploadViewModel())
}