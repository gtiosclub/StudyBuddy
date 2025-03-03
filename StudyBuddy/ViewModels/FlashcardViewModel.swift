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
    @Published var flashcards: [FlashcardModel] = []
    @Published var currentlyChosenFlashcard = FlashcardModel(text: "", createdBy: "")
    private let db = Firestore.firestore()
    private var user = UserViewModel.shared.user
    private var currentlyChosenStudySet = StudySetViewModel.shared.currentlyChosenStudySet
    
    func createFlashcardDocument() -> () {
        guard let userDocumentID = user.id, let studySetDocumentID = currentlyChosenStudySet.id else {
            print("Error: either user.documentID or currentlyChosenStudyset.documentID is nil")
            return
        }
        
        let ref = db.collection("Users").document(userDocumentID).collection("StudySets").document(studySetDocumentID).collection("Flashcards")
        
        do {
            let newDocReference = try ref.addDocument(from: self.currentlyChosenFlashcard)
            print("New flashcard docuemnt stored with reference: \(newDocReference)")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchFlashcards() -> () {
        guard let userDocumentID = user.id, let studySetDocumentID = currentlyChosenStudySet.id else {
            print("Error: either user.documentID or currentlyChosenStudyset.documentID is nil")
            return
        }
        
        let ref = db.collection("Users").document("\(userDocumentID)").collection("StudySets").document("\(studySetDocumentID)").collection("Flashcards")
        
        ref.getDocuments { querySnapshot, error in
            if let error {
                print("Error getting document: \(error.localizedDescription)")
            }
            
            guard let documents = querySnapshot?.documents else {
                print("Error getting documents")
                return
            }
            
            do {
                self.flashcards = try documents.map { document in
                    try document.data(as: FlashcardModel.self)
                }
            } catch {
                print("Error decoding flashcards: \(error.localizedDescription)")
            }
            
//            for document in documents {
//                let data = document.data()
//                let text = data["text"] as? String ?? ""
//                let createdBy = data["createdBy"] as? String ?? ""
//                self.flashcards.append(FlashcardModel(text: text, createdBy: createdBy))
//            }
        }
    }
    
    func updateFlashcardData() -> () {
        guard let userDocumentID = user.id, let studySetDocumentID = currentlyChosenStudySet.id, let flashcardDocumentID = currentlyChosenFlashcard.id else {
            print("Error: either user.documentID, currentlyChosenStudyset.documentID, or currentlyChosenStudySet.documentID is nil")
            return
        }
        
        let ref = db.collection("Users").document("\(userDocumentID)").collection("StudySets").document("\(studySetDocumentID)").collection("Flashcards").document(flashcardDocumentID)
        
        do {
            try ref.setData(from: self.currentlyChosenFlashcard)
        } catch {
            print("Error updating flashcard data \(error.localizedDescription)")
        }
       
//        ref.updateData([
//            "text" : currentlyChosenFlashcard.text,
//            "createdBy" : currentlyChosenFlashcard.createdBy,
//        ])
//        
    }
    
    
    
    func deleteFlashcardData() -> () {
        guard let userDocumentID = user.id, let studySetDocumentID = currentlyChosenStudySet.id, let flashcardDocumentID = currentlyChosenFlashcard.id else {
            print("Error: either user.documentID or currentlyChosenStudyset.documentID is nil")
            return
        }
        
        let ref = db.collection("Users").document("\(userDocumentID)").collection("StudySets").document("\(studySetDocumentID)").collection("Flashcards").document("\(flashcardDocumentID)")
        
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
