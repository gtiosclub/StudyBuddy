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

    func fetchFlashcardsFromIDs() async throws -> [FlashcardModel] {
        guard let setID = currentlyChosenStudySet.id else {
            print("Error: currentlyChosenStudySet.id is nil")
            throw NSError(domain: "FlashcardViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "StudySet ID is nil"])
        }

        let ref = db.collection("StudySets").document(setID)
        let document = try await ref.getDocument()

        guard let flashcardIDs = document.data()?["flashcardIDs"] as? [String] else {
            print("Error: flashcardIDs is nil")
            throw NSError(domain: "FlashcardViewModel", code: 2, userInfo: [NSLocalizedDescriptionKey: "Flashcard IDs are nil"])
        }

        print("Flashcard IDs: \(flashcardIDs)")
        
        var results: [FlashcardModel] = []

            for flashcard in flashcardIDs {
                let ref = db.collection("Flashcards").document(flashcard)
                do {
                    let flashcard = try await ref.getDocument(as: FlashcardModel.self)

                    self.flashcards.append(flashcard)
                    results.append(flashcard)
                    StudySetViewModel.shared.currentlyChosenStudySet.flashcards.append(flashcard)

                    print(flashcard)
                } catch {
                    print("Error fetching flashcard: \(error.localizedDescription)")
                    continue
                }
            }
        
        return results
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
            print("Updated flashcard data")
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
