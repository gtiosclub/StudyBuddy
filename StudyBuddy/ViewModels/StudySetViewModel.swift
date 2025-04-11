//
//  StudySetViewModel.swift
//  StudyBuddy
//
//  Created by John Mermigkas on 2/20/25.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

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
}
