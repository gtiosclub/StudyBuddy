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
    @StateObject private var viewModel = FileViewerViewModel()
    @StateObject private var uploadViewModel = UploadViewModel()
    @StateObject private var fileLibraryViewModel = FileLibraryViewModel()
    @State private var selection: FileName = .allFile
    @State private var isPickerPresented: Bool = false

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
                    AllView(fileLibraryViewModel: fileLibraryViewModel)
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
            .sheet(isPresented: $uploadViewModel.isUploadPresented) {
                UploadView(uploadViewModel: uploadViewModel)
                    .presentationDetents([.medium, .fraction(0.5)])
            }
        }
    }
}

struct AllView: View {
    @ObservedObject var fileLibraryViewModel: FileLibraryViewModel

    var body: some View {
        ScrollView {
            HStack {
                ForEach(fileLibraryViewModel.fileLibrary, id: \.self) { document in
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
