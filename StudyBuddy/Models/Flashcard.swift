//
//  Flashcard.swift
//  StudyBuddy
//
//  Created by John Mermigkas on 2/11/25.
//

import Foundation
import FirebaseFirestore
struct FlashcardModel: Identifiable, Codable {
    @DocumentID var id: String?
    var front: String
    var back: String
    var createdBy: String
    var mastered: Bool

    init(id: String? = nil, front: String, back: String, createdBy: String, mastered: Bool) {
        self.id = id ?? UUID().uuidString
        self.front = front
        self.back = back
        self.createdBy = createdBy
        self.mastered = mastered
    }
}
