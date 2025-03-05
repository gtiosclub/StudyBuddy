//
//  FileViewer.swift
//  StudyBuddy
//
//  Created by alina on 2025/3/3.
//

import SwiftUI

struct FileViewer: View {
    @StateObject private var viewModel = FileViewerViewModel()

    var body: some View {
        NavigationView {
            List($viewModel.files) { $file in
                VStack(alignment: .leading) {
                    Text(file.name) // Display file name
                    Text("Size: \(file.size) bytes") // Display file size
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Created: \(file.createdAt, style: .date)") // Display creation date
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("File Viewer")
            .toolbar {
                NavigationLink(destination: UploadView()) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    FileViewer()
}
