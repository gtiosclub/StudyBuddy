//
//  StudySetViewModel.swift
//  StudyBuddy
//
//  Created by John Mermigkas on 2/20/25.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

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
            print(error.localizedDescription)
        }
    }

    func fetchStudySets() {
        for studySet in studySets {
            guard let studySetDocumentID = studySet.id else {
                print("Error: Document ID is nil")
                return
            }
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
}
