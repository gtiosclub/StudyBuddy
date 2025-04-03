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
                
                //this stores the correct updated document values
                self.uploadDocument(document: document)
            }
        }
    }
    func uploadDocument(document: Document) {
        let collectionRef = Firestore.firestore().collection("Documents")
        do {
            var newDocument = document
            let docRef = try collectionRef.addDocument(from: newDocument)
            newDocument.firestoreDocumentId = docRef.documentID
            print("Document stored in FileViewModel\(docRef.documentID)")
        } catch {
            print("Error in FileViewModel while doing uploadDocument \(error)")
        }
    }
}
