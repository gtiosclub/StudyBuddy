import SwiftUI

struct StudyView: View {
    @ObservedObject var studySet: StudySetModel
    @State private var flashCardIndex = 0
    @State private var showBack = false

    var body: some View {
        VStack {
            Spacer()
            Spacer()
            cardView()
            Spacer()
            navBar()
            Spacer()
        }
    }
    private func cardView() -> some View {
        // Ensure index is within bounds
        if studySet.flashcards.indices.contains(flashCardIndex) {
            return AnyView(
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue)
                        .frame(width: 300, height: 200)
                        .shadow(radius: 5)
                    Text(showBack ?
                            studySet.flashcards[flashCardIndex].back :
                            studySet.flashcards[flashCardIndex].front)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .onTapGesture {
                    showBack.toggle()
                }
            )
        } else {
            return AnyView(Text("No flashcard available"))
        }
    }

    private func navBar() -> some View {
        HStack {
            Button(action: {
                if flashCardIndex > 0 {
                    flashCardIndex -= 1
                    showBack = false
                }
            }) {
                HStack {
                    Image(systemName: "arrow.left")
                    Text("Left")
                }
            }
            Button(action: {
                if flashCardIndex < studySet.flashcards.count - 1 {
                    flashCardIndex += 1
                    showBack = false
                }
            }) {
                HStack {
                    Text("Right")
                    Image(systemName: "arrow.right")
                }
            }
        }
    }
}

#Preview {
    let sampleFlashcards = [
        FlashcardModel(front: "Hello", back: "World", createdBy: "Calvin", mastered: false),
        FlashcardModel(front: "Swift", back: "UI", createdBy: "Calvin", mastered: false),
        FlashcardModel(front: "SwiftUI", back: "Is awesome", createdBy: "Calvin", mastered: false)
    ]
    // Assuming StudySetModel is now a class conforming to ObservableObject.
    let sampleStudySet = StudySetModel(flashcards: sampleFlashcards, dateCreated: Date(), createdBy: "Calvin")
    StudyView(studySet: sampleStudySet)
}
