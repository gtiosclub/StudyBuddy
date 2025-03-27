//
//  UserViewModel.swift
//  StudyBuddy
//
//  Created by Madhumita Subbiah on 4/3/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserViewModel: ObservableObject {
    @Published var user: User?

    private let database = Firestore.firestore()

    // Store user data in Firestore
    func storeUserData(uid: String, firstName: String, lastName: String, email: String) {
        let user = User(id: uid, firstName: firstName, lastName: lastName, email: email, profileImageURL: nil)
        
        database.collection("users").document(uid).setData([
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "profileImageURL": nil
        ], merge: true)
    }

    // Fetch user data from Firestore
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                self.user = User(
                    id: uid,
                    firstName: data?["firstName"] as? String ?? "",
                    lastName: data?["lastName"] as? String ?? "",
                    email: data?["email"] as? String ?? "",
                    profileImageURL: data?["profileImageURL"] as? String
                )
            }
        }
    }
}
