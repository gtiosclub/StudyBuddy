//
//  AddView.swift
//  StudyBuddy
//
//  Created by Jihoon Kim on 2/25/25.
//

import SwiftUI

struct AddView: View {
    @State private var frontText: String = ""
    @State private var backText: String = ""
    var set: [String: (String, String)]
    var studySet: StudySet
    init(studySet: StudySet) {
        self.studySet = studySet
        self.set = studySet.set
    }
    var body: some View {
        NavigationView {
            VStack {
                // Flashcard form
                VStack {
                    TextField("Enter front of flashcard", text: $frontText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    TextField("Enter back of flashcard", text: $backText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button(action: {
                        if !frontText.isEmpty && !backText.isEmpty {
                            studySet.add_flashcard(front: frontText, back: backText)
                            frontText = ""
                            backText = ""
                        }
                    }) {
                        Text("Add Flashcard")
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .navigationTitle("Add Flashcard")
        }
    }
}

struct FlashCardApp_Previews: PreviewProvider {
    static var previews: some View {
        let hardSet = StudySet(set : ["String" : ("String","String")])
        AddView(studySet: hardSet)
    }
}
