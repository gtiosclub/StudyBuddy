//
//  FileViewer.swift
//  StudyBuddy
//
//  Created by alina on 2025/3/3.
//

import SwiftUI

enum FileName: String, CaseIterable, Identifiable {
    case allFile = "All Files"
    case recent = "Recents"
    case favorites = "Favorites"
    case folders = "Folders"

    var id: String { self.rawValue }
}

struct FileViewer: View {
    @StateObject private var fileViewerViewModel = FileViewerViewModel()
    @State private var selection: FileName = .allFile

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // File Library Section
                Text("File Library")
                    .font(.title)
                    .bold()
                    .padding(.horizontal)

                Picker("Select a tab", selection: $selection) {
                    ForEach(FileName.allCases) { file in
                        Text(file.rawValue).tag(file)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // Content based on selected tab
                switch selection {
                case .allFile:
                    AllView(fileViewerViewModel: FileViewerViewModel())
                case .recent:
                    Text("Recents View")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .favorites:
                    Text("Favorites View")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .folders:
                    Text("Folders View")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
}

struct AllView: View {
    @ObservedObject var fileViewerViewModel = FileViewerViewModel()

    var body: some View {
        ScrollView {
            HStack {
                ForEach(fileViewerViewModel.fileLibrary, id: \.self) { document in
                    VStack {
                        Image(systemName: "doc")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .padding(4)
                        Text(document)
                            .scaledToFit()
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    FileViewer()
}