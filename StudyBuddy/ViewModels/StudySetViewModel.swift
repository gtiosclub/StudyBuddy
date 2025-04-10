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
    // singleton var
    static let shared = StudySetViewModel()
    @Published var studySets: [StudySetModel] = []
    //initially empty instead of having to make it optional and deal with nil everywhere
    @Published var currentlyChosenStudySet: StudySetModel = StudySetModel(flashcards: [], dateCreated: Date(), createdBy: "")
    private let db = Firestore.firestore()
    private var user: UserModel = UserViewModel.shared.user
    func createStudySetDocument() {
        let ref = db.collection("StudySets")
        do {
            let newDocReference = try ref.addDocument(from: self.currentlyChosenStudySet)
            print("StudySet stored with new document reference: \(newDocReference)")
        } catch {
            print(error.localizedDescription)
        }
//
//        db.document("Users/\(userDocumentID)/StudySets/\(studySetDocumentID)").setData([
//            "list" : currentlyChosenStudySet.list,
//            "dateCreated" : currentlyChosenStudySet.dateCreated,
//            "createdBy" : currentlyChosenStudySet.createdBy,
//        ])
    }
    func fetchStudySets() {
        for studySet in user.studySets {
            guard let studySetDocumentID = studySet.id else {
                print("Error: Document ID is nil")
                return
            }
//            let studySetDocumentID = "VnLPYjY9q4nCBj8BR7qk"
            let ref = db.collection("StudySets").document(studySetDocumentID)
            do {
                ref.getDocument(as: StudySetModel.self) { result in
                    switch result {
                    case .success(let studySet):
                        print("Successfully fetched data")
                        self.studySets.append(studySet)
                    case .failure(let error):
                        print("Error decoding document: \(error.localizedDescription)")
                    }
                }
            }
        }
//        guard let studySetDocumentID = currentlyChosenStudySet.id else {
//            print("Error: Document ID is nil")
//            return
//        }
//        let ref = db.collection("StudySets").document(studySetDocumentID)
//        ref.getDocuments { querySnapshot, error in
//            if let error {
//                print("Error getting document: \(error.localizedDescription)")
//                return
//            }
//
//            //the ?. operator is used in optional chaining it means "if querySnapshot is not nil, access.documents
//            //if its nil the whole expression evaluates to nil and the guard runs the else block
//            guard let documents = querySnapshot?.documents else {
//                print("No study sets found")
//                return
//            }
//
//            do {
//                //map is a higher order functiont hat transforms each element in a collection
//                //and returns a new array
//                self.studySets = try documents.map { document in
//                    try document.data(as: StudySetModel.self)
//                }
//            } catch {
//                print("Error decoding study sets: \(error.localizedDescription)")
//            }

    }
    //function that updates a spefici stored study set with the new values saved in currently chosen studyset
    func updateStudySetData() {
        guard let studySetDocumentID = currentlyChosenStudySet.id else {
            print("Error: currentlyChosenStudyset.id is nil")
            return
        }
//        let studySetDocumentID = "VnLPYjY9q4nCBj8BR7qk"
        let ref = db.collection("StudySets").document("\(studySetDocumentID)")
        do {
            //merge important so it doesn't overwrite
            try ref.setData(from: self.currentlyChosenStudySet, merge: true)
            print("Successfully updated data")
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
    func deleteStudySetData() {
        guard let studySetDocumentID = currentlyChosenStudySet.id else {
            print("Error: currentlyChosenStudyset.documentID is nil")
            return
        }
//        let studySetDocumentID = "VnLPYjY9q4nCBj8BR7qk"
        let ref = db.collection("StudySets").document("\(studySetDocumentID)")
        ref.delete { error in
            //swift infers that this is if let error = error
            if let error {
                print("Error deleting document: \(error.localizedDescription)")
            } else {
                print("Document successfully deleted")
            }
        }
    }
    func testFunctions() {
//        user.studySets.append(StudySetModel(flashcards: [], dateCreated: Date(), createdBy: "tester"))
//        currentlyChosenStudySet = StudySetModel(flashcards: [], dateCreated: Date(), createdBy: "eileen")
//        studySets.append(currentlyChosenStudySet)
////        updateStudySetData()
//        deleteStudySetData()
//        createStudySetDocument()

//        fetchStudySets()
        //        updateUserData()
    }
}
