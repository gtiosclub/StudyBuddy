//
//  FlashcardViewModel.swift
//  StudyBuddy
//
//  Created by John Mermigkas on 2/20/25.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
class FlashcardViewModel {
    static let shared = FlashcardViewModel()
    @Published var flashcards: [FlashcardModel] = []
    @Published var currentlyChosenFlashcard = FlashcardModel(text: "", createdBy: "")
    private let db = Firestore.firestore()
    private var user = UserViewModel.shared.user
    private var currentlyChosenStudySet = StudySetViewModel.shared.currentlyChosenStudySet
    func createFlashcardDocument() {
        let ref = db.collection("Flashcards")
        do {
            let newDocReference = try ref.addDocument(from: self.currentlyChosenFlashcard)
            print("New flashcard docuemnt stored with reference: \(newDocReference)")
        } catch {
            print(error.localizedDescription)
        }
    }
    func fetchFlashcards() {
        for flashcard in currentlyChosenStudySet.flashcards {
            guard let flashcardDocumentID = flashcard.id else {
                print("flashcardDocumentID is nil")
                return
            }
//            let flashcardDocumentID = "nTukpvPyc6ca2492rcR1"
            let ref = db.collection("Flashcards").document(flashcardDocumentID)
            do {
                ref.getDocument(as: FlashcardModel.self) { result in
                    switch result {
                    case .success(let flashcard):
                        print("Successfully fetched data")
                        self.flashcards.append(flashcard)
                    case .failure(let error):
                        print("Error decoding document: \(error.localizedDescription)")
                    }
                }
            }
        }
        //        guard let userDocumentID = user.id, let studySetDocumentID = currentlyChosenStudySet.id else {
        //            print("Error: either user.documentID or currentlyChosenStudyset.documentID is nil")
        //            return
        //        }
        //
        //        let ref = db.collection("Users").document("\(userDocumentID)").collection("StudySets").document("\(studySetDocumentID)").collection("Flashcards")
        //
        //        ref.getDocuments { querySnapshot, error in
        //            if let error {
        //                print("Error getting document: \(error.localizedDescription)")
        //            }
        //
        //            guard let documents = querySnapshot?.documents else {
        //                print("Error getting documents")
        //                return
        //            }
        //
        //            do {
        //                self.flashcards = try documents.map { document in
        //                    try document.data(as: FlashcardModel.self)
        //                }
        //            } catch {
        //                print("Error decoding flashcards: \(error.localizedDescription)")
        //            }
        //
        ////            for document in documents {
        ////                let data = document.data()
        ////                let text = data["text"] as? String ?? ""
        ////                let createdBy = data["createdBy"] as? String ?? ""
        ////                self.flashcards.append(FlashcardModel(text: text, createdBy: createdBy))
        ////            }
        //        }
    }
    func updateFlashcardData() {
        guard let flashcardDocumentID = currentlyChosenFlashcard.id else {
            print("Error: currentlyChosenFlashcard.documentID is nil")
            return
        }
//        let flashcardDocumentID = "nTukpvPyc6ca2492rcR1"
        let ref = db.collection("Flashcards").document(flashcardDocumentID)
        do {
            try ref.setData(from: self.currentlyChosenFlashcard)
        } catch {
            print("Error updating flashcard data \(error.localizedDescription)")
        }
    }
    func deleteFlashcardData() {
        guard let flashcardDocumentID = currentlyChosenFlashcard.id else {
            print("Error: flashcardDocumentID is nil")
            return
        }
//                    let flashcardDocumentID = "nTukpvPyc6ca2492rcR1"

        let ref = db.collection("Flashcards").document(flashcardDocumentID)
        ref.delete { error in
            // swift infers that this is if let error = error
            if let error {
                print("Error deleting document: \(error.localizedDescription)")
            } else {
                print("Document successfully deleted")
            }
        }
    }
    func testFunctions() {
////        createFlashcardDocument() <--- works
//        currentlyChosenStudySet = StudySetModel(flashcards: [], dateCreated: Date(), createdBy: "eileen")
//        currentlyChosenFlashcard = FlashcardModel(text:"testing", createdBy: "johnthetester")
//        deleteFlashcardData()
//    }
}
