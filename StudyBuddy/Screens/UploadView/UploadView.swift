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
    }
}
