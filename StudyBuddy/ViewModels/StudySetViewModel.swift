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
    static let shared = StudySetViewModel()

    @Published var studySets: [StudySetModel] = []
    @Published var currentlyChosenStudySet: StudySetModel = StudySetModel(flashcards: [], dateCreated: Date(), createdBy: "")

    private let db = Firestore.firestore()

    func createStudySetDocument() {
        let ref = db.collection("StudySets")
        do {
            let newDocRef = try ref.addDocument(from: currentlyChosenStudySet)
            print("StudySet stored: \(newDocRef)")
        } catch {
            print("Error storing StudySet: \(error.localizedDescription)")
        }
    }

    func fetchStudySets() {
        guard let user = UserViewModel.shared.user else {
            print("User not loaded yet")
            return
        }

        for studySet in user.studySets {
            guard let studySetDocumentID = studySet.id else {
                print("Missing StudySet ID")
                continue
            }

            let ref = db.collection("StudySets").document(studySetDocumentID)
            ref.getDocument(as: StudySetModel.self) { result in
                switch result {
                case .success(let fetchedSet):
                    DispatchQueue.main.async {
                        self.studySets.append(fetchedSet)
                    }
                case .failure(let error):
                    print("Error fetching set: \(error.localizedDescription)")
                }
            }
        }
    }

    func updateStudySetData() {
        guard let id = currentlyChosenStudySet.id else {
            print("No ID on current study set")
            return
        }

        let ref = db.collection("StudySets").document(id)
        do {
            try ref.setData(from: currentlyChosenStudySet, merge: true)
            print("StudySet updated")
        } catch {
            print("Failed to update: \(error.localizedDescription)")
        }
    }

    func deleteStudySetData() {
        guard let id = currentlyChosenStudySet.id else {
            print("No ID on current study set")
            return
        }

        db.collection("StudySets").document(id).delete { error in
            if let error {
                print("Delete failed: \(error.localizedDescription)")
            } else {
                print("StudySet deleted successfully")
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
