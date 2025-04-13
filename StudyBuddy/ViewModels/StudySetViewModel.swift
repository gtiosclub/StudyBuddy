//
//  FlashcardViewModel.swift
//  StudyBuddy
//
//  Created by John Mermigkas on 2/20/25.

import Foundation
import FirebaseCore
import FirebaseFirestore
import SwiftUICore

class StudySetViewModel: ObservableObject {
    // singleton var
    static let shared = StudySetViewModel()
    // list of all studysets
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
            print("Error creating document: \(error.localizedDescription)")
        }
    }

    func fetchStudySets() {
        for studySet in user.studySets {
            guard let studySetDocumentID = studySet.id else {
                print("Error: Document ID is nil")
                return
            }
//            let studySetDocumentID = "VnLPYjY9q4nCBj8BR7qk"
            let ref = db.collection("StudySets").document(studySetDocumentID)
            ref.getDocument(as: StudySetModel.self) { result in
                switch result {
                case .success(let studySet):
                    print("Successfully fetched data for study set with id: \(studySetDocumentID)")
                    DispatchQueue.main.async {
                        self.studySets.append(studySet)
                    }
                case .failure(let error):
                    print("Error decoding document: \(error.localizedDescription)")
                }
            }
        }
    }

    //function that updates a spefici stored study set with the new values saved in currently chosen studyset
    func updateStudySetData() {
        guard let studySetDocumentID = currentlyChosenStudySet.id else {
            print("Error: currentlyChosenStudySet.id is nil")
            return
        }
        let ref = db.collection("StudySets").document(studySetDocumentID)
        do {
        //  merge important so it doesn't overwrite
            try ref.setData(from: self.currentlyChosenStudySet, merge: true)
            print("Successfully updated study set data")
        } catch {
            print("Error updating study set data: \(error.localizedDescription)")
        }
    }

    //cleares the data stored in this instance
    func deleteStudySetData() {
        guard let studySetDocumentID = currentlyChosenStudySet.id else {
            print("Error: currentlyChosenStudySet.documentID is nil")
            return
        }
        let ref = db.collection("StudySets").document(studySetDocumentID)
        ref.delete { error in
            if let error = error {
                print("Error deleting document: \(error.localizedDescription)")
            } else {
                print("Document successfully deleted")
            }
        }
    }
    func addFlashcard(front: String, back: String, createdBy: String = "USERIDNEEDTOINPUT") {
        let newFlashcard = FlashcardModel(front: front, back: back, createdBy: createdBy, mastered: false)
        currentlyChosenStudySet.flashcards.append(newFlashcard)
        // reassign to trigger published (idk if this is the best way)?
        currentlyChosenStudySet = currentlyChosenStudySet
        updateStudySetData()
    }
    func deleteFlashcard(_ flashcard: FlashcardModel) {
        guard let index = currentlyChosenStudySet.flashcards.firstIndex(where: { card in
            return card.id == flashcard.id
        }) else {
            return
        }

        currentlyChosenStudySet.flashcards.remove(at: index)
        currentlyChosenStudySet = currentlyChosenStudySet
        updateStudySetData()
    }
    
    func editFlashcard(flashcard: FlashcardModel, newFront: String, newBack: String) {
        // Find the index of the flashcard in the flashcards array
        guard let index = currentlyChosenStudySet.flashcards.firstIndex(where: { $0.id == flashcard.id }) else {
            print("Flashcard not found!")
            return
        }

        // Update the flashcard's content
        currentlyChosenStudySet.flashcards[index].front = newFront
        currentlyChosenStudySet.flashcards[index].back = newBack

        // Reassigning currentlyChosenStudySet triggers the @Published property to update the UI
        currentlyChosenStudySet = currentlyChosenStudySet

        // Update the study set document in Firestore so the changes are persisted
        updateStudySetData()
    }

    func getUser() -> String {
        return currentlyChosenStudySet.createdBy
    }
}
