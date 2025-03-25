import SwiftUI
import FirebaseStorage
import FirebaseFirestore

class UploadViewModel: ObservableObject {
    @Published var selectedDocumentNames: [String] = []
    @Published var documents: [Document] = []
    @Published var isUploadPresented: Bool = false
    private let storage = Storage.storage(url: "gs://studybuddy-7df38.appspot.com")
    private let db = Firestore.firestore()

    // Save document to firebase and firestore
    func saveDocumentToFirebase(_ document: Document, isPublic: Bool) {
        // Create a reference to firebase
        let storageRef = storage.reference().child("documents/\(document.fileName)")
        print("Uploading to path: documents/\(document.fileName)")
        
        // Convert document content to data
        guard let data = document.content.data(using: .utf8) else {
            print("Error: Document content is nil or cannot be converted to data")
            return
        }
        print("Document data size: \(data.count) bytes")
        
        // Upload the file to Firebase Storage
        storageRef.putData(data, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading to Storage: \(error)")
                return
            }
            // Get the download URL
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error)")
                    return
                }
                guard let downloadURL = url else {
                    print("Error: Download URL is nil")
                    return
                }
                print("File uploaded successfully. Download URL: \(downloadURL.absoluteString)")
                
                // Create Firestore document
                let docData: [String: Any] = [
                    "fileName": document.fileName,
                    "content": document.content,
                    "parsedContent": document.parsedContent ?? "",
                    "dateCreated": document.dateCreated,
                    "storageURL": downloadURL.absoluteString,
                    "isPublic": isPublic
                ]
                // Save to Firestore
                self.db.collection("Documents").document(document.id.uuidString).setData(docData) { error in
                    if let error = error {
                        print("Error saving to Firestore: \(error)")
                    } else {
                        print("Document saved to Firestore successfully.")
                    }
                }
            }
        }
    }
}