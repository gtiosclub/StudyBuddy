import SwiftUI

struct AddView: View {
    @ObservedObject var studySetVM: StudySetViewModel
    @State private var frontText: String = ""
    @State private var backText: String = ""
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("Term", text: $frontText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                TextField("Definition", text: $backText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: {
                    if !frontText.isEmpty && !backText.isEmpty {
                        // Use the view model's helper method to add the new flashcard
                        studySetVM.addFlashcard(front: frontText, back: backText)
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

                Spacer()
            }
            .navigationTitle("Add Flashcard")
            .background(Color(hex: "#321C58").edgesIgnoringSafeArea(.all))
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleFlashcards = [
            FlashcardModel(front: "Example Front", back: "Example Back", createdBy: "Example User", mastered: false)
        ]

        let sampleStudySet = StudySetModel(flashcards: sampleFlashcards, dateCreated: Date(), createdBy: "User")

        let sampleVM = StudySetViewModel.shared
        sampleVM.currentlyChosenStudySet = sampleStudySet

        return AddView(studySetVM: sampleVM)
    }
}
