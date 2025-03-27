//
//  Flashcard.swift
//  StudyBuddy
//
//  Created by John Mermigkas on 2/11/25.
//

import Foundation
import FirebaseFirestore
struct FlashcardModel: Identifiable, Codable {
    @DocumentID var id: String? /*= UUID().uuidString*/ //temporary for local use
    var text: String
    var createdBy: String
    var mastered: Bool
}
