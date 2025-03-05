//
//  FileViewer.swift
//  StudyBuddy
//
//  Created by alina on 2025/3/3.
//

import SwiftUI

struct FileViewer: View {
    @StateObject private var viewModel = FileViewerViewModel()
    @State private var isPickerPresented = false
    @StateObject private var uploadViewModel = UploadViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.files) { file in
                VStack(alignment: .leading) {
                    Text(file.fileName) // Display file name
                    Text("Content: \(file.content)") // Display file content
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Created: \(file.dateCreated, style: .date)") // Display creation date
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("File Viewer")
            .toolbar {
                Button(action: {
                    withAnimation {
                        isPickerPresented = true
                    }    
                }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $isPickerPresented) {
                DocumentPickerView(uploadViewModel: uploadViewModel)
            }
        }
    }
}

#Preview {
    FileViewer()
}
