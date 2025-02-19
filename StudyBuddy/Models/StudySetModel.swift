//
//  StudySetModel.swift
//  StudyBuddy
//
//  Created by Tejeshwar Natarajan on 2/6/25.
//

import Foundation
struct StudySetModel: Identifiable {
    //contains a list of flashcards objects
    //includes meta data when it was created who created it etc
    let id = UUID()
    var list: [Flashcard] = []
    let dateCreated: Date //date format
    let createdBy: String
    //create multiple study sets and initialize it with values
}
