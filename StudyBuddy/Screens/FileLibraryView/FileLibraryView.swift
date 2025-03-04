//
//  FileLibraryView.swift
//  StudyBuddy
//
//  Created by Tony Nguyen on 2/27/25.
//

import SwiftUI

enum FileName: String, CaseIterable, Identifiable {
    case allFile = "All Files"
    case recent = "Recents"
    case favorites = "Favorites"
    case folders = "Folders"

    var id: String { self.rawValue }
}

struct FileLibraryView: View {
    @State private var selection: FileName = .allFile
    @StateObject var uploadViewModel = UploadViewModel()
    @StateObject var fileLibraryViewModel = FileLibraryViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            Text("File Library")
                .font(.title)
                .bold()

            Picker("Select a tab", selection: $selection) {
                ForEach(FileName.allCases) { file in
                    Text(file.rawValue).tag(file)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            VStack {
                switch selection {
                case .allFile:
                    Spacer()
                    AllView(fileLibraryViewModel: fileLibraryViewModel)
                case .recent:
                    Text("Recents View")
                case .favorites:
                    Text("Favorites View")
                case .folders:
                    Text("Folders View")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
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
