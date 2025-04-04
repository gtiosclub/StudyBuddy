//
//  UploadView.swift
//  StudyBuddy
//
//  Created by Tony Nguyen on 2/11/25.
//
import SwiftUI

struct UploadView: View {
    // ViewModel to manage uploaded documents
    @ObservedObject var uploadViewModel: UploadViewModel
    // State variable to control the upload file visibility
    @State private var isPublic = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 30) {
            if !uploadViewModel.selectedDocumentNames.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Selected Documents:")
                        .font(.title2)
                        .bold()
                    ForEach(uploadViewModel.selectedDocumentNames, id: \.self) { document in
                        Text(document)
                            .padding(5)
                            .font(.body)
                    }
                }
                .padding()
            }

            Text("Select Privacy")
                .font(.title2)
                .bold()
                .padding(.top)

            HStack {
                Text("Private")
                    .foregroundColor(.blue)
                    .bold()
                    .font(.title3)
                Toggle("", isOn: $isPublic)
                    .toggleStyle(SwitchToggleStyle(tint: .green))
                    .labelsHidden()
                Text("Public")
                    .foregroundColor(.green)
                    .bold()
                    .font(.title3)
            }
            .padding()

            Button(action: {
                // Handle upload action
                for document in uploadViewModel.documents {
                    var doc: Document = document
                    doc.isPrivate = !isPublic
                    // update call to upload the file to Firebase
                    uploadViewModel.uploadFileToFirebase(
                        fileName: document.fileName,
                        fileData: document.fileData!,
                        document: doc,
                        isPublic: isPublic
                    )
                }
                // Close the view and reset flags
                print("Uploaded")
                presentationMode.wrappedValue.dismiss()
                uploadViewModel.isUploadPresented = false
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Upload Files")
                }
                .font(.title3)
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
            .tint(isPublic ? .green : .blue)
            .bold()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(40)
    }
}

#Preview {
    UploadView(uploadViewModel: UploadViewModel())
}
