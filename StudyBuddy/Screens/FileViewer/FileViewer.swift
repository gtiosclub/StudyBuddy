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
    @State private var add: Bool = false
    @State private var selectedDocuments: [Document] = []
    @EnvironmentObject private var studySetViewModel: StudySetViewModel
    @State var presentSets: Bool = false
    @State private var isDocumentPickerPresented = false // State to control DocumentPickerView presentation
    @State private var isUploadViewPresented = false
    @StateObject private var uploadViewModel = UploadViewModel() // Added UploadViewModel instance

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // File Library Section
                HStack {
                    Text("File Library")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color(hex: "#E0D7FF")) // Softer light purple
                        .padding(.horizontal)
                    if !selectedDocuments.isEmpty {
                        Button(action: {
                            presentSets.toggle()
                        }) {
                            Text("Add Set")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(Color(hex: "#E0D7FF")) // Softer light purple
                                .padding(.horizontal)
                        }
                    }
                        Spacer()
                    
                    Button(action: {
                        isDocumentPickerPresented = true
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                            .foregroundColor(Color(hex: "#A3C4F3")) // Softer blue
                            .padding(.horizontal)
                    }
                }
                Picker("Select a tab", selection: $selection) {
                    ForEach(FileName.allCases) { file in
                        Text(file.rawValue).tag(file)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .background(Color(hex: "#5A3E85")) // Slightly lighter purple for better contrast
                .cornerRadius(8)

                switch selection {
                case .allFile:
                    AllView(fileViewerViewModel: fileViewerViewModel, isAddMode: $add, selectedDocuments: $selectedDocuments)
                case .recent:
                    Text("Recents View")
                        .foregroundColor(Color(hex: "#E0D7FF")) // Softer light purple
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .favorites:
                    AllView(fileViewerViewModel: fileViewerViewModel, isFavoritesView: true, isAddMode: $add, selectedDocuments: $selectedDocuments) // Use AllView for Favorites
                case .folders:
                    Text("Folders View")
                        .foregroundColor(Color(hex: "#E0D7FF")) // Softer light purple
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .background(Color(hex: "#432A6E").edgesIgnoringSafeArea(.all)) // Adjusted purple for better contrast
            .sheet(isPresented: $fileViewerViewModel.isPresentingFilePreview, onDismiss: {
                fileViewerViewModel.selectedFileURL = nil
                fileViewerViewModel.localFileURL = nil
            }) {
                if let url = fileViewerViewModel.localFileURL {
                    QLPreviewView(url: url, isPresented: $fileViewerViewModel.isPresentingFilePreview)
                } else if fileViewerViewModel.isLoading {
                    ProgressView("Downloading File...")
                        .foregroundColor(Color(hex: "#E0D7FF")) // Softer light purple
                } else if let error = fileViewerViewModel.errorMessage {
                    Text("Error: \(error)").foregroundColor(Color(hex: "#FFB3B3")) // Softer red for errors
                }
            }
            .sheet(isPresented: $presentSets) {
                SelectSet(isPresented: $presentSets, selectedDocuments: $selectedDocuments)

            }
            .sheet(isPresented: $isDocumentPickerPresented) {
                DocumentPickerView(uploadViewModel: uploadViewModel) // Present DocumentPickerView
            }
            .sheet(isPresented: $isUploadViewPresented) {
                UploadView(uploadViewModel: uploadViewModel) // Present UploadView
            }
            .onChange(of: uploadViewModel.isUploadPresented) { isPresented in
                if isPresented {
                    uploadViewModel.selectedDocumentNames = []
                    isUploadViewPresented = true
                }
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
    var isFavoritesView: Bool = false // New flag
    @Binding var isAddMode: Bool
    @Binding var selectedDocuments: [Document]

    var body: some View {
        ScrollView {
            if fileViewerViewModel.isLoading {
                ProgressView("Fetching Documents...")
                    .foregroundColor(Color(hex: "#E0D7FF")) // Softer light purple
            } else if let errorMessage = fileViewerViewModel.errorMessage {
                Text("Error: \(errorMessage)").foregroundColor(.red)
            } else {
                let displayedDocuments = isFavoritesView ? fileViewerViewModel.favoriteDocuments : fileViewerViewModel.documents

                if displayedDocuments.isEmpty {
                    Text("No documents found.")
                        .foregroundColor(Color(hex: "#E0D7FF")) // Softer light purple
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(displayedDocuments) { document in
                            DocumentItemView(document: document,
                                             viewModel: fileViewerViewModel,
                                             isAddMode: $isAddMode, selectedDocuments: $selectedDocuments)
                        }
                    }
                    // .padding()
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
    @Binding var isAddMode: Bool
    @Binding var selectedDocuments: [Document]

    @State private var isSelected = false
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                if document.type == .folder {
                    Image(systemName: "folder.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                        .padding(4)
                } else {
                    Image(systemName: "doc.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                        .padding(4)

                }
                Text(document.fileName)
                    .font(.caption)
                    .lineLimit(1)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(hex: "#5A3E85")) // Slightly lighter purple for document items
            .cornerRadius(8)
            if isAddMode {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? .green : .gray)
                    .padding(6)
            }

        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(hex: "#5A3E85")) // Slightly lighter purple for document items
        .cornerRadius(8)
        .onTapGesture {
            if isAddMode {
                if !selectedDocuments.contains(where: { $0.id == document.id }) {
                    selectedDocuments.append(document)
                } else {
                    print("Document already selected")
                }
                isSelected.toggle()
                print(selectedDocuments.count)
                
            } else {
                viewModel.openFile(document: document)
            }
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
                dismissButton: .default(Text("OK").foregroundColor(Color(hex: "#A3C4F3"))) // Softer blue for alert button
            )
        }
    }
    func presentFavoritesActionSheet() {
        // Implement action sheet or context menu for favorites
        print("Long pressed on \(document.fileName)")
        // Example using an action sheet (requires a @State var to control presentation)
        // You'll need to add a @State var in AllView to handle this.
        // isPresentingFavoritesOptions = true
    }
}
struct SelectSet: View {
    @EnvironmentObject private var studySetViewModel: StudySetViewModel
    @Binding var isPresented: Bool
    @Binding var selectedDocuments: [Document]

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(studySetViewModel.studySets) { set in
                        StudySetCard(set: set)
                            .onTapGesture {
                                handleStudySetSelection(set: set)
                                //show something that says sucess here
                                isPresented = false
                            }
                    }
                }
                .padding(.top)
            }

        }
    }

    private func handleStudySetSelection(set: StudySetModel) {
        studySetViewModel.updateStudySetDocument(studySet: set, documents: selectedDocuments)
    }
}

struct StudySetCard: View {
    var set: StudySetModel

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                Text(set.name)
                    .font(.headline)

                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 20, height: 20)
                    Text("john_doe18")
                        .foregroundColor(.black)
                        .font(.subheadline)
                }

                Text("48 terms")
                    .font(.subheadline)
                    .foregroundColor(.black)

                Text("23 terms mastered")
                    .font(.subheadline)
                    .foregroundColor(.black)

                Spacer().frame(height: 6)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .background(Color(hex: "#71569E")) // Adjusted purple for card background
        .cornerRadius(12)
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}



#Preview {
    FileViewer()
}
