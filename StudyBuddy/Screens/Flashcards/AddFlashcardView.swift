//
//  AddFlashcardView.swift
//  StudyBuddy
//
//  Created by Dennis Nguyen on 2/18/25.
//

import SwiftUI

struct FlashCardApp: View {
    @State private var frontText: String = ""
    @State private var backText: String = ""
    @StateObject private var studySet = StudySet(set: [:])

    

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
        FlashCardApp()
    }
}
