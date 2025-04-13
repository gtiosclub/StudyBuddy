//
//  FileViewer.swift
//  StudyBuddy
//
//  Created by alina on 2025/3/3.
//
import SwiftUI
import QuickLook

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
    @State private var isDocumentPickerPresented = false // State to control DocumentPickerView presentation
    @State private var isUploadViewPresented = false
    @StateObject private var uploadViewModel = UploadViewModel() // Added UploadViewModel instance

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {

                HStack {
                    Text("File Library")
                        .font(.title)
                        .bold()
                    Spacer()
                    Button(action: {
                        isDocumentPickerPresented = true
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Upload")
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    }
                }
                .padding(.horizontal)

                Picker("Select a tab", selection: $selection) {
                    ForEach(FileName.allCases) { file in
                        Text(file.rawValue).tag(file)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .background(Color(hex: "#71569E"))
                .cornerRadius(8)

                switch selection {
                case .allFile:
                    AllView(fileViewerViewModel: fileViewerViewModel)
                case .recent:
                    Text("Recents View")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .favorites:
                    AllView(fileViewerViewModel: fileViewerViewModel, isFavoritesView: true)
                case .folders:
                    Text("Folders View")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .background(Color(hex: "#321C58").edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $fileViewerViewModel.isPresentingFilePreview, onDismiss: {
                fileViewerViewModel.selectedFileURL = nil
                fileViewerViewModel.localFileURL = nil
            }) {
                if let url = fileViewerViewModel.localFileURL {
                    QLPreviewView(url: url, isPresented: $fileViewerViewModel.isPresentingFilePreview)
                } else if fileViewerViewModel.isLoading {
                    ProgressView("Downloading File...")
                        .foregroundColor(.white)
                } else if let error = fileViewerViewModel.errorMessage {
                    Text("Error: \(error)").foregroundColor(.red)
                }
            }
            .sheet(isPresented: $isDocumentPickerPresented) {
                DocumentPickerView(uploadViewModel: uploadViewModel) // Present DocumentPickerView
            }
            .sheet(isPresented: $isUploadViewPresented) {
                UploadView(uploadViewModel: uploadViewModel)
            }
            .onChange(of: uploadViewModel.isUploadPresented) { isPresented in
                if isPresented {
                    isUploadViewPresented = true
                }
            .onDisappear() {
                print("Snap Listener has closed.")
                fileViewerViewModel.closeSnapshotListener()
            }
        }
    }
}

struct QLPreviewView: UIViewControllerRepresentable {
    let url: URL
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> UINavigationController {
        let previewController = QLPreviewController()
        previewController.dataSource = context.coordinator
        let navigationController = UINavigationController(rootViewController: previewController)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: context.coordinator, action: #selector(context.coordinator.dismissPreview))
        previewController.navigationItem.rightBarButtonItem = doneButton
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(url: url, isPresented: $isPresented)
    }

    class Coordinator: NSObject, QLPreviewControllerDataSource {
        let previewItemURL: URL
        @Binding var isPresented: Bool

        init(url: URL, isPresented: Binding<Bool>) {
            self.previewItemURL = url
            _isPresented = isPresented
            super.init()
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int { 1 }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return previewItemURL as NSURL as QLPreviewItem
        }

        @objc func dismissPreview() {
            isPresented = false
        }
    }
}

struct AllView: View {
    @ObservedObject var fileViewerViewModel: FileViewerViewModel
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    var isFavoritesView: Bool = false

    var body: some View {
        ScrollView {
            if fileViewerViewModel.isLoading {
                ProgressView("Fetching Documents...")
                    .foregroundColor(.white)
            } else if let errorMessage = fileViewerViewModel.errorMessage {
                Text("Error: \(errorMessage)").foregroundColor(.red)
            } else {
                let displayedDocuments = isFavoritesView ? fileViewerViewModel.favoriteDocuments : fileViewerViewModel.documents

                if displayedDocuments.isEmpty {
                    Text("No documents found.")
                        .foregroundColor(.white)
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(displayedDocuments) { document in
                            DocumentItemView(document: document, viewModel: fileViewerViewModel)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct DocumentItemView: View {
    let document: Document
    @ObservedObject var viewModel: FileViewerViewModel
    @State private var isShowingFavoriteAlert = false
    @State private var favoriteAlertMessage = ""

    var body: some View {
        VStack {
            Image(systemName: document.type == .folder ? "folder.fill" : "doc.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
                .padding(4)

            Text(document.fileName)
                .font(.caption)
                .lineLimit(1)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(hex: "#71569E"))
        .cornerRadius(8)
        .onTapGesture {
            viewModel.openFile(document: document)
        }
        .onLongPressGesture {
            viewModel.toggleFavorite(document: document)
            favoriteAlertMessage = document.isFavorite
                ? "\(document.fileName) removed from Favorites"
                : "\(document.fileName) added to Favorites"
            isShowingFavoriteAlert = true
        }
        .alert(isPresented: $isShowingFavoriteAlert) {
            Alert(
                title: Text("Favorites"),
                message: Text(favoriteAlertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
