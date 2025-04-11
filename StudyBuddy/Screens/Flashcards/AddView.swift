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
                VStack(spacing: 20) {
                    TextField("Enter front of flashcard", text: $frontText)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)

                    TextField("Enter back of flashcard", text: $backText)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)

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
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "#6213D0"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle("Add Flashcard")
            .background(Color(hex: "#321C58").edgesIgnoringSafeArea(.all))
        }
    }
}

struct FlashCardApp_Previews: PreviewProvider {
    static var previews: some View {
        let hardSet = StudySet(set: ["String": ("String", "String")])
        AddView(studySet: hardSet)
    }
}
