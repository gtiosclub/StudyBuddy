//
//  StudySetModel.swift
//  StudyBuddy
//
//  Created by Tejeshwar Natarajan on 2/6/25.
//

import Foundation

class StudySet: ObservableObject {
    @Published var set: [String: String]

    init(set: [String: String]) {
        self.set = set
    }
}
