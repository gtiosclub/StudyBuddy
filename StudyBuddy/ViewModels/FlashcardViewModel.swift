//
//  FlashcardViewModel.swift
//  StudyBuddy
//
//  Created by John Mermigkas on 2/20/25.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
class FlashcardViewModel: ObservableObject {
    static let shared = FlashcardViewModel()
    @Published var flashcards: [FlashcardModel] = []
    @Published var currentlyChosenFlashcard = FlashcardModel(front: "", back: "", createdBy: "", mastered: false)
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
//
//    func editFlashCardData(front: String, back: String) {
//        
//    }
    func testFunctions() {
        ////        createFlashcardDocument() <--- works
        //        currentlyChosenStudySet = StudySetModel(flashcards: [], dateCreated: Date(), createdBy: "eileen")
        //        currentlyChosenFlashcard = FlashcardModel(text:"testing", createdBy: "johnthetester")
        //        deleteFlashcardData()
        //    }
    }
}
