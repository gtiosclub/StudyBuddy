//
//  FlashcardViewModel.swift
//  StudyBuddy
//
//  Created by John Mermigkas on 2/20/25.

import Foundation
import FirebaseCore
import FirebaseFirestore
import SwiftUICore

class StudySetViewModel: ObservableObject, Identifiable {
    @Published var studySets: [StudySetModel] = []

    private let db = Firestore.firestore()
    @Published var currentlyChosenStudySet: StudySetModel = StudySetModel(flashcards: [], dateCreated: Date(), createdBy: "", name: "", documentIDs: [])
    private var documentsListener: ListenerRegistration?
    
    public func listenToUserDocuments() {
        documentsListener = db.collection("StudySets")
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else {
                    print("Error getting documents in StudySetViewModel: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                DispatchQueue.main.async {
                    self.studySets = snapshot.documents.compactMap { document in
                        do {
                            let decodedDoc = try document.data(as: StudySetModel.self)
                            return decodedDoc
                        } catch {
                            print("Error decoding document in fileviewModel: \(error)")
                            return nil
                        }
                    }
                    
                }
            }
    }
    public func closeSnapshotListener() {
        documentsListener?.remove()
    }
    
    
    func updateStudySetDocument(studySet: StudySetModel, documents: [Document]) {
        guard let studySetID = studySet.id else {
            print(studySet)
            print("Document ID not found in updateStudySetDocument.")
            return
        }
        let documentIDs = documents.map { $0.id }
        let docRef = db.collection("StudySets").document(studySetID)
        print(documentIDs)
        docRef.updateData([
            "documentIDs": FieldValue.arrayUnion(documentIDs)
        ]) { error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
            }
        }
    }
    func createStudySetDocument(studySet: StudySetModel) {
        let ref = db.collection("StudySets")
        do {
            let newDocReference = try ref.addDocument(from: studySet)
            print("StudySet stored with new document reference: \(newDocReference)")
        } catch {
            print("Error storing StudySet: \(error.localizedDescription)")
        }
    }
    func createStudySetDocumentAndReturn(studySet: StudySetModel) async throws -> StudySetModel {
        let ref = try db.collection("StudySets").addDocument(from: studySet)
        var updatedStudySet = studySet
        updatedStudySet.id = ref.documentID
        return updatedStudySet
    }


    func fetchStudySets() {
        for studySet in studySets {
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
    //function that updates a spefici stored study set with the new values saved in currently chosen studyset
    func updateStudySetData(studySet: StudySetModel) {
        guard let studySetDocumentID = studySet.id else {
            print("Error: currentlyChosenStudyset.id is nil")
            return
        }
        let ref = db.collection("StudySets").document("\(studySetDocumentID)")
        do {
//            try ref.updateData(from: studySet)
            print("Successfully updated data")
        } catch {
            print("Error updating study set data \(error.localizedDescription)")
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
