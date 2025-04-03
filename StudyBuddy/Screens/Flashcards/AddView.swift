import SwiftUI

struct AddView: View {
    // Now using an ObservableObject of type StudySetModel
    @ObservedObject var studySet: StudySetModel
    @State private var frontText: String = ""
    @State private var backText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    TextField("Term", text: $frontText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    TextField("Definition", text: $backText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button(action: {
                        if !frontText.isEmpty && !backText.isEmpty {
                            // Create a new flashcard and add it to the study set
                            let newFlashcard = FlashcardModel(front: frontText, back: backText, createdBy: "USERIDNEEDTOINPUT", mastered: false)
                            studySet.flashcards.append(newFlashcard)
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

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample flashcard and study set for preview
        let sampleFlashcards = [
            FlashcardModel(front: "Example Front", back: "Example Back", createdBy: "Example User", mastered: false)
        ]
        let sampleStudySet = StudySetModel(flashcards: sampleFlashcards, dateCreated: Date(), createdBy: "User")
        AddView(studySet: sampleStudySet)
    }
}
