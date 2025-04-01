import SwiftUI
import FirebaseStorage
import FirebaseFirestore

class UploadViewModel: ObservableObject {
    @Published var selectedDocumentNames: [String] = []
    @Published var documents: [Document] = []
    @Published var isUploadPresented: Bool = false
    private let storage = Storage.storage(url: "gs://studybuddy-7df38.firebasestorage.app")
    private let database = Firestore.firestore()

    // Stores object in Cloud Storage and saves information to Documents Collection in Firestore
    func uploadFileToFirebase(fileName: String, fileData: Data, document: Document, isPublic: Bool) {
        // Creates a reference in Firebase Storage
        let storageRef = storage.reference().child("documents/\(fileName)")

        // Error logging
        print("Uploading to path: documents/\(fileName)")
        print("File data size: \(fileData.count) bytes")

        // Upload the file to Firebase Storage
        storageRef.putData(fileData, metadata: nil) { _, error in
            if let error = error {
                print("Error uploading to Storage: \(error)")
                return
            }
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
                self.database.collection("Documents").document(document.id.uuidString).setData(docData) { error in
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
