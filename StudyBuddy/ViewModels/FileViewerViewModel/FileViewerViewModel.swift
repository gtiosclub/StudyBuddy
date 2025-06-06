//
//  FileViewerViewModel.swift
//  StudyBuddy
//
//  Created by Tony Nguyen on 2/27/25.
//
import Foundation
import FirebaseStorage
import QuickLook
import FirebaseAuth
import FirebaseFirestore
class FileViewerViewModel: ObservableObject {
    @Published var documents: [Document] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var selectedFileURL: URL?
    @Published var isPresentingFilePreview: Bool = false
    @Published var localFileURL: URL?
    private let db = Firestore.firestore()
    private var documentsListener: ListenerRegistration?
    private let storage = Storage.storage()
    private let storagePath = "documents/"

    init() {
        fetchDocumentsFromStorage()
    }

    public func listenToUserDocuments() {
        let userID = Auth.auth().currentUser?.uid ?? "user not found"
        let storageReference = storage.reference().child(storagePath)
        documentsListener = db.collection("Documents")
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else {
                    print("Error getting documents in fileViewerViewModel: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                DispatchQueue.main.async {
                    self.documents = snapshot.documents.compactMap { document in
                        do {
                            let decodedDoc = try document.data(as: Document.self)
                            // Only include documents that belong to the current user
                            if decodedDoc.userID == userID {
                                return decodedDoc
                            } else {
                                return nil
                            }
                        } catch {
                            print("Error decoding document in fileviewModel: \(error)")
                            return nil
                        }
                    }
//                    for index in 0..<self.documents.count {
//                        let document = self.documents[index]
//                        let fileReference = storageReference.child(document.fileName)
//                        fileReference.downloadURL { (url, error) in
//                            if let error = error as NSError? {
//                                print("Error getting download URL for \(document.fileName): \(error.localizedDescription) (Code: \(error.code), Domain: \(error.domain))")
//                            } else if let downloadURL = url {
//                                DispatchQueue.main.async {
//                                    self.documents[index].fileURL = downloadURL.absoluteString
//                                }
//                            }
//                        }
//                    }
                    for document in self.documents {
                        let fileReference = storageReference.child(document.fileName)
                        fileReference.downloadURL { (url, error) in
                            if let error = error as NSError? {
                                print("Error getting download URL for \(document.fileName): \(error.localizedDescription) (Code: \(error.code), Domain: \(error.domain))")
                            } else if let downloadURL = url {
                                DispatchQueue.main.async {
                                    guard let index = self.documents.firstIndex(where: { $0.id == document.id }) else { return }
                                    self.documents[index].fileURL = downloadURL.absoluteString
                                }
                            }
                        }
                    }
                }
            }
    }

    public func closeSnapshotListener() {
        documentsListener?.remove()
    }
    
    func fetchDocumentsFromStorage() {
        isLoading = true
        errorMessage = nil
        documents = []

        let storageReference = storage.reference().child(storagePath)

        storageReference.listAll { (result, error) in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "Error fetching files from Storage: \(error.localizedDescription)"
                    print("Error fetching files from Storage: \(error)")
                    return
                }
                self.listenToUserDocuments()
            }
        }
    }

    // Function to handle opening a file
        func openFile(document: Document) {
            guard let remoteFileURL = document.fileURL, let url = URL(string: remoteFileURL) else {
                print("Invalid file URL for \(document.fileName)")
                return
            }
            print("Opening file: \(document.fileName) at URL: \(url)")
            selectedFileURL = url
            downloadAndPresentFile(from: url)
        }

        private func downloadAndPresentFile(from remoteURL: URL) {
            isLoading = true
            errorMessage = nil
            let fileName = remoteURL.lastPathComponent
            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let localFile = documentsDirectoryURL.appendingPathComponent(fileName)

            // Check if the file is already downloaded
            if FileManager.default.fileExists(atPath: localFile.path) {
                print("File already downloaded at: \(localFile)")
                self.localFileURL = localFile
                self.isPresentingFilePreview = true
                self.isLoading = false
                return
            }

            URLSession.shared.downloadTask(with: remoteURL) { (location, response, error) in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let error = error {
                        self.errorMessage = "Error downloading file: \(error.localizedDescription)"
                        print("Error downloading file: \(error)")
                        return
                    }

                    guard let tempLocation = location else {
                        self.errorMessage = "Error: No temporary file location found."
                        print("Error: No temporary file location found.")
                        return
                    }

                    do {
                        try FileManager.default.moveItem(at: tempLocation, to: localFile)
                        print("File downloaded successfully to: \(localFile)")
                        self.localFileURL = localFile
                        self.isPresentingFilePreview = true
                    } catch {
                        self.errorMessage = "Error moving downloaded file: \(error.localizedDescription)"
                        print("Error moving downloaded file: \(error)")
                    }
                }
            }.resume()
        }
    func toggleFavorite(document: Document) {
        if let index = documents.firstIndex(where: { $0.id == document.id }) {
            documents[index].isFavorite.toggle()
            print("\(documents[index].fileName) is now favorite: \(documents[index].isFavorite)")
            // In a real app, you would likely want to persist this state (e.g., in Firestore or locally).
        }
    }

    // Computed property to filter favorite documents
    var favoriteDocuments: [Document] {
        return documents.filter { $0.isFavorite }
    }


    //created simple method to get documents from database
    func getDocument(documentID: String) async -> Document? {
        let docRef = db.collection("Documents").document(documentID)
        do {
            let document = try await docRef.getDocument(as: Document.self)
            return document
        } catch {
            print("Error in FileViewModel while doing getDocument \(error)")
            return nil
        }
    }
    

}
