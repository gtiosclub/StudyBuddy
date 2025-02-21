//
//  StudySetModel.swift
//  StudyBuddy
//
//  Created by Tejeshwar Natarajan on 2/6/25.
//

import Foundation

class StudySet: ObservableObject {
    @Published var set: [String: (String, String)]

    init(set: [String: (String, String)]) {
        self.set = set

    }

    func add_flashcard(front: String, back: String) {

        self.set["\(set.count)"] = (front, back)
    }

    func edit_flashcard(key: String, front: String, back: String) {

        self.set[key] = (front, back)
    }

}
