//
//  StudySetViewModel.swift
//  StudyBuddy
//
//  Created by John Mermigkas on 2/20/25.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class StudySetViewModel {
    //singleton var
    static let shared = StudySetViewModel()
    @Published var studySets: [StudySetModel] = []
    //initially empty instead of having to make it optional and deal with nil everywhere
    @Published var currentlyChosenStudySet: StudySetModel = StudySetModel(list: [], dateCreated: Date(), createdBy: "")
    private let db = Firestore.firestore()
    private let user: UserModel = UserViewModel.shared.user
    
    
    
    func createStudySetDocument() -> () {
        guard let userDocumentID = user.id else {
            print("Error: user.id is nil")
            return
        }
        
        let ref = db.collection("Users").document(userDocumentID).collection("StudySets")
        
        do {
            let newDocReference = try ref.addDocument(from: self.currentlyChosenStudySet)
            print("StudySet stored with new document reference: \(newDocReference)")
        }
        catch {
            print(error.localizedDescription)
        }
        
//        
//        db.document("Users/\(userDocumentID)/StudySets/\(studySetDocumentID)").setData([
//            "list" : currentlyChosenStudySet.list,
//            "dateCreated" : currentlyChosenStudySet.dateCreated,
//            "createdBy" : currentlyChosenStudySet.createdBy,
//        ])
    }
    
    //When user logs in, this function should be called which fetches the data related to the currently logged-in user and stores it in this current user instance
    func fetchStudySets() -> () {
        guard let documentID = user.id else {
            print("Error: Document ID is nil")
            return
        }
        let ref = db.collection("Users").document("\(documentID)").collection("StudySets")
        ref.getDocuments { querySnapshot, error in
            if let error {
                print("Error getting document: \(error.localizedDescription)")
                return
            }
            
            //the ?. operator is used in optional chaining it means "if querySnapshot is not nil, access.documents
            //if its nil the whole expression evaluates to nil and the guard runs the else block
            guard let documents = querySnapshot?.documents else {
                print("No study sets found")
                return
            }
            
            do {
                //map is a higher order functiont hat transforms each element in a collection
                //and returns a new array
                self.studySets = try documents.map { document in
                    try document.data(as: StudySetModel.self)
                }
            } catch {
                print("Error decoding study sets: \(error.localizedDescription)")
            }
            
//            
//            for document in documents {
//                let data = document.data()
//                let list = data["list"] as? [FlashcardModel] ?? []
//                //firestore stores dates as Timestamps
//                let dateCreated: Date
//                if let timestamp = data["dateCreated"] as? Timestamp {
//                    dateCreated = timestamp.dateValue() //conver to date
//                } else {
//                    dateCreated = Date() //default value
//                }
//                let createdBy = data["createdBy"] as? String ?? ""
//                self.studySets.append(StudySetModel(list: list, dateCreated: dateCreated, createdBy: createdBy))
//            }
        }
    }
    
    //function that updates a spefici stored study set with the new values saved in currently chosen studyset
    func updateStudySetData() -> () {
        guard let userDocumentID = user.id, let studySetDocumentID = currentlyChosenStudySet.id else {
            print("Error: either user.id or currentlyChosenStudyset.id is nil")
            return
        }
        
        let ref = db.collection("Users").document("\(userDocumentID)").collection("StudySets").document("\(studySetDocumentID)")
        
        do {
            //merge important so it doesn't overwrite
            try ref.setData(from: self.currentlyChosenStudySet, merge: true)
        } catch {
            print("Error updating study set data \(error.localizedDescription)")
        }
        
//        ref.updateData([
//            "list" : currentlyChosenStudySet.list,
//            "dateCreated" : currentlyChosenStudySet.dateCreated,
//            "createdBy" : currentlyChosenStudySet.createdBy,
//        ])
        
    }
    
    
    
    //cleares the data stored in this instance
    func deleteStudySetData() -> () {
        guard let userDocumentID = user.id, let studySetDocumentID = currentlyChosenStudySet.id else {
            print("Error: either user.documentID or currentlyChosenStudyset.documentID is nil")
            return
        }
        
        let ref = db.collection("Users").document("\(userDocumentID)").collection("StudySets").document("\(studySetDocumentID)")
        
        ref.delete { error in
            //swift infers that this is if let error = error
            if let error {
                print("Error deleting document: \(error.localizedDescription)")
            } else {
                print("Document successfully deleted")
            }
        }
    }
}
