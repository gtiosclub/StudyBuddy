//
//  Flashcard.swift
//  StudyBuddy
//
//  Created by John Mermigkas on 2/11/25.
//

import Foundation
struct Flashcard: Identifiable {
    let id = UUID()
    var text: String
    let createdBy: String
}
