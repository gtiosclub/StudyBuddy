//
//  StudySetModel.swift
//  StudyBuddy
//
//  Created by Tejeshwar Natarajan on 2/6/25.
//

import Foundation
import FirebaseFirestore
struct StudySetModel: Identifiable, Codable {
    //contains a list of flashcards objects
    //includes meta data when it was created who created it etc
    @DocumentID var id: String? /* = UUID().uuidString*/ //temporary for local use
    var flashcards: [FlashcardModel]
    var dateCreated: Date //date format
    var createdBy: String
    var name: String
    var documentIDs: [String]
    //create multiple study sets and initialize it with values
}
