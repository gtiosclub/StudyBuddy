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
    // State variable to control document picker presentation
    @State private var isPickerPresented = false
    // State variable to control the upload file visibility
    @State private var isPublic = false
    var body: some View {
        VStack {
            // Button to open document picker
            Button(action: {
                isPickerPresented = true
            }, label: {
                Text("Select Document")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            })
            // Display selected document names if any
            if !uploadViewModel.selectedDocumentNames.isEmpty {
                VStack(alignment: .leading) {
                    Text("Selected Documents:")
                        .font(.headline)
                    // List each selected document name
                    ForEach(uploadViewModel.selectedDocumentNames, id: \.self) { document in
                        Text(document)
                            .padding(5)
                    }
                }
                .padding()
            }
        }
        .padding()
        // Present the document picker when triggered
        .sheet(isPresented: $isPickerPresented) {
            DocumentPickerView(uploadViewModel: uploadViewModel)
        }
        VStack(spacing: 20) {
            Spacer()

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
            Button { // display upload files button
            } label: {
                Image(systemName:
                        "square.and.arrow.up")
                Text("Upload Files")
            }
            .buttonStyle(.borderedProminent)
            .tint(isPublic ? .green : .blue)
            .bold()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    UploadView()
}
