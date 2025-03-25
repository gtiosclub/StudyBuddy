//
//  StudySetModel.swift
//  StudyBuddy
//
//  Created by Tejeshwar Natarajan on 2/6/25.
//

import Foundation
class StudySetModel: Identifiable {
    // contains a list of flashcards objects
    // includes meta data when it was created who created it etc
    let id = UUID()
    var name: String
    var list: [Flashcard] = []
    let dateCreated: Date // date format
    let createdBy: String
    // create multiple study sets and initialize it with values

    init(name: String) {
        self.name = name
        self.dateCreated = Date()
        self.createdBy = "Me"
    }
    
    func add_flashcard(front: String, back: String) {
        var newFlashcard = Flashcard(front: front, back: back)
        list.append(newFlashcard)
    }
    
    func remove_flashcard(id: UUID) {
        if let index = list.firstIndex(where: { $0.id == id }) {
            list.remove(at: index)
        }
    }
}
