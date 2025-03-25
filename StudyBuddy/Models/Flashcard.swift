//
//  Flashcard.swift
//  StudyBuddy
//
//  Created by John Mermigkas on 2/11/25.
//

import Foundation
class Flashcard: ObservableObject {
    let id = UUID()
    var front: String
    var back: String
    
    init(front: String, back: String){
        self.front = front
        self.back = back
    }
    
    func edit_card(new_front: String, new_back: String) {
        self.front = new_front
        self.back = new_back
    }
}
