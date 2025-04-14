//
//  UserViewModel.swift
//  StudyBuddy
//
//  Created by Tejeshwar Natarajan on 2/6/25.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class UserViewModel: ObservableObject {
    // Shared singleton instance
    static let shared = UserViewModel()

    // Optional published user object for SwiftUI reactivity
    @Published var user: UserModel? = nil

    private let db = Firestore.firestore()

    // Create user document in Firestore
    func createUserDocument() {
        guard let user = self.user else { return }

        let ref = db.collection("Users")
        do {
            let newDocReference = try ref.addDocument(from: user)
            print("Added the user document: \(newDocReference)")
        } catch {
            print("Error creating user document: \(error.localizedDescription)")
        }
    }

    // Fetch user data for currently logged in Firebase user
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Error: No authenticated user")
            return
        }

        let ref = db.collection("Users").document(uid)
        ref.getDocument(as: UserModel.self) { result in
            switch result {
            case .success(let fetchedUser):
                DispatchQueue.main.async {
                    self.user = fetchedUser
                    print("Fetched user: \(fetchedUser.userName)")
                }
            case .failure(let error):
                print("Error fetching user data: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchUserName(documentID: String, completion: @escaping (_ firstName: String?, _ lastName: String?) -> Void) {
        
        let docRef = db.collection("Users").document(documentID)
        
        docRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                completion(nil, nil)
                return
            }
            
            guard let document = document, document.exists, let data = document.data() else {
                print("Document does not exist for id: \(documentID)")
                completion(nil, nil)
                return
            }
            
            let firstName = data["firstName"] as? String
            print(firstName)
            let lastName = data["lastName"] as? String
            
            completion(firstName, lastName)
        }
    }

    // Update the current user’s Firestore document
    func updateUserData() {
        guard let documentID = user?.id else {
            print("ERROR: User ID is nil")
            return
        }
        guard let user = self.user else { return }

        let ref = db.collection("Users").document(documentID)
        do {
            try ref.setData(from: user, merge: true)
        } catch {
            print("Error updating user data: \(error.localizedDescription)")
        }
    }

    // Clear the current user data
    func clearUserData() {
        self.user = nil
    }
}
