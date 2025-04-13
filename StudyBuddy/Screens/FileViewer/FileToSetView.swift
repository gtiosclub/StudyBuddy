//
//  FileToSetView.swift
//  StudyBuddy
//
//  Created by Tony Nguyen on 4/10/25.
//

import Foundation
import SwiftUI
import QuickLook

struct FileToSetView: View {
    @StateObject private var fileViewerViewModel = FileViewerViewModel()
    @State private var selection: FileName = .allFile
    @State private var add: Bool = true
    @State private var selectedDocuments: [Document] = []
    @EnvironmentObject private var studySetViewModel: StudySetViewModel
    @State var presentSets: Bool = false
    @State var addSet: StudySetModel
    @Binding var showPopup: Bool
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // File Library Section
                HStack {
                    Text("File Library")
                        .font(.title)
                        .bold()
                        .padding(.horizontal)
                    if !selectedDocuments.isEmpty {
                        Button(action: {
                            studySetViewModel.updateStudySetDocument(studySet: addSet, documents: selectedDocuments)
                            showPopup = false
                        }) {
                            Text("Add Set")
                        }
                    }
                        Spacer()
                    
                }
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
                    AllView(fileViewerViewModel: fileViewerViewModel, isAddMode: $add, selectedDocuments: $selectedDocuments)
                case .recent:
                    Text("Recents View")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .favorites:
                    AllView(fileViewerViewModel: fileViewerViewModel, isFavoritesView: true, isAddMode: $add, selectedDocuments: $selectedDocuments) // Use AllView for Favorites
                case .folders:
                    Text("Folders View")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .sheet(isPresented: $fileViewerViewModel.isPresentingFilePreview, onDismiss: {
                fileViewerViewModel.selectedFileURL = nil
                fileViewerViewModel.localFileURL = nil
            }) {
                if let url = fileViewerViewModel.localFileURL {
                    QLPreviewView(url: url, isPresented: $fileViewerViewModel.isPresentingFilePreview)
                } else if fileViewerViewModel.isLoading {
                    ProgressView("Downloading File...")
                } else if let error = fileViewerViewModel.errorMessage {
                    Text("Error: \(error)")
                }
            }
            .sheet(isPresented: $presentSets) {
                SelectSet(isPresented: $presentSets, selectedDocuments: $selectedDocuments)

            }
            .onAppear {
                fileViewerViewModel.listenToUserDocuments()
            }
            .onDisappear() {
                print("Snap Listener has closed.")
                fileViewerViewModel.closeSnapshotListener()
            }
        }

    }
}






