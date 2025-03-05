import SwiftUI
import FirebaseStorage
import FirebaseFirestore

class UploadViewModel: ObservableObject {
    @Published var selectedDocumentNames: [String] = []
    private let storage = Storage.storage()
    private let db = Firestore.firestore()
    
    // Save document to firebase and firestore
    func saveDocumentToFirebase(_ document: Document) {
        // Create a reference to firebase
        let storageRef = storage.reference().child("documents/\(document.fileName)")
        
        // Convert document content to data
        guard let data = document.content.data(using: .utf8) else {
            print("Error: Document content is nil or cannot be converted to data")
            return
        }
        
        // Upload the file to Firebase Storage
        storageRef.putData(data, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading to Storage: \(error)")
                return
            }
            
            // Get the download URL
            storageRef.downloadURL { url, error in
                guard let downloadURL = url else { return }
                
                // Create Firestore document
                let docData: [String: Any] = [
                    "fileName": document.fileName,
                    "content": document.content,
                    "parsedContent": document.parsedContent ?? "",
                    "dateCreated": document.dateCreated,
                    "storageURL": downloadURL.absoluteString
                ]
                
                // Save to Firestore
                self.db.collection("Documents").document(document.id.uuidString).setData(docData) { error in
                    if let error = error {
                        print("Error saving to Firestore: \(error)")
                    }
                }
            }
        }
    }
}