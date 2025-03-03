//
//  UserViewModel.swift
//  StudyBuddy
//
//  Created by Tejeshwar Natarajan on 2/6/25.
//

import Foundation

import FirebaseCore
import FirebaseFirestore

class UserViewModel {
    //singleton var so we have 1 global instance that we can access from anywhere
    static let shared = UserViewModel()
    @Published var user = UserModel()
    private let db = Firestore.firestore()
    
    //When adding a new document, Cloud Firestore will automatically take care of assigning a new document ID to the document. This even works when the app is currently offline.
    //https://firebase.google.com/docs/firestore/solutions/swift-codable-data-mapping
    //Firestore automatically assigns the Firestore document ID to id when fetching data.
    func createUserDocument() -> () {
        do {
            let newDocReference = try db.collection("Users").addDocument(from: self.user)
            print("Added the user document: \(newDocReference)")
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    
    //When user logs in, this function should be called which fetches the data related to the currently logged-in user and stores it in this current user instance
    func fetchUserData() -> () {
        //unwrap the user.id to use it in the rest of the code
        guard let documentID = user.id else {
            print("Error: Document ID is nil")
            return
        }
        
        let ref = db.collection("Users").document(documentID)
        
        //UserModel.self refers to the struct
        //this uses the codable protocol
        ref.getDocument(as: UserModel.self) { result in
            switch result {
            case .success(let user):
                self.user = user
            case .failure(let error):
                print("Error decoding document: \(error.localizedDescription)")
            }
        }
        
        //get the document which takes a function of type
        //(DocumentSnapshot?, Error?) -> Void
//        ref.getDocument { documentSnapshot, error in
//            //means error is not null so unwrapped
//            if let error {
//                print("Error getting document: \(error.localizedDescription)")
//            }
//            else if let documentSnapshot, documentSnapshot.exists {
//                //unwrap data
//                if let data = documentSnapshot.data() {
//                    //when you use dot snytax it passes back a new copy of this struct with the changed value
//                    self.user.email = data["email"] as? String ?? ""
//                    self.user.userName = data["userName"] as? String ?? ""
//                    self.user.studySets = data["studySets"] as? [StudySetModel] ?? []
//                    
//                    //as? returns either the value or nil so we can use nil coalescing operator "??"
//                    self.user.id = data["id"] as? String ?? UUID().uuidString
//                }
//            }
//        }
    }
        
    //updates all the values stored in the database of the currently logged in user when called (updates values stored in the database from the currentuser instances)
    func updateUserData() -> () {
        //guard does not permit you to continue if userid is nil
        //if it is not nil then we unwrap it and have access to it for
        //the rest of the scope here
        guard let documentID = user.id else {
            print("ERROR: User ID is nil")
            return
        }
        let ref = db.collection("Users").document(documentID)
        do {
            //merge important so doesn't overwrite the other data
            try ref.setData(from: self.user, merge: true)
        }
        catch {
            print("Error updating user data \(error.localizedDescription)")
        }
        
        //this was manual. Keep in case i need to change it
//        ref.updateData([
//            "email" : user.email,
//            "userName" : user.userName,
//            "studySets" : user.studySets,
//            "id" : user.id ?? "",
//        ]) { error in
//            if let error = error {
//                print("Error updating user data: \(error.localizedDescription)")
//            } else {
//                print("User data updated successfully!")
//            }
//        }
    }
    
    //cleares the data stored in this instance
    func clearUserData() -> () {
        user.email = ""
        user.userName = ""
        user.studySets = []
        user.id = nil
    }
}
