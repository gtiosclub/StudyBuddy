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
    // State variable to control additional Upload Button
    @State private var showUploadButton = false
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
        
        VStack (spacing: 20) {
            Spacer()
            // if showUploadButton is true, then display two new buttons
            if showUploadButton {
                Button { // display upload files button
                    withAnimation {
                        showUploadButton = true
                    }
                } label: {
                    Image(systemName:
                            "square.and.arrow.up")
                    Text("Upload Files")
                }
                .buttonStyle(.borderedProminent)
                .tint(.black)
                .bold()
                Button { // displays Go Back button
                    withAnimation {
                        showUploadButton = false;
                    }
                    
                }  label: {
                    Image(systemName:
                            "chevron.left")
                    Text("Go Back")
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .bold()
            } else { // if showUploadButton is false
                Button { // display public upload option
                    withAnimation {
                        showUploadButton = true
                    }
                } label: {
                    Image(systemName:
                            "square.and.arrow.up")
                    Text("Upload (Public)")
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .bold()

                Button { // display private upload option
                    withAnimation {
                        showUploadButton = true
                    }
                } label: {
                    Image(systemName:
                            "square.and.arrow.up")
                    Text("Upload (Private)")
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .bold()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .animation(.easeInOut, value: showUploadButton)
    }
}
