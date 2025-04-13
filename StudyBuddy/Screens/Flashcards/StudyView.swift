import SwiftUI

struct StudyView: View {

    // Using the view model for study sets instead of the model directly
    @ObservedObject var studySetVM: StudySetViewModel
    @State private var flashCardIndex = 0
    @State private var showBack = false
    


    var body: some View {
        VStack {
            Spacer()
            cardView()
            Spacer()
            navBar()
            Spacer()
        }
    }

    private func cardView() -> some View {
        let flashcards = studySetVM.currentlyChosenStudySet.flashcards
        if flashcards.indices.contains(flashCardIndex) {
            return AnyView(
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue)
                        .frame(width: 300, height: 200)
                        .shadow(radius: 5)
                    Text(showBack ? flashcards[flashCardIndex].back : flashcards[flashCardIndex].front)
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

    // nav bar to switch carfs
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
                    Text("Previous")
                }
                .padding()
                .foregroundColor(.white)
                .background(Color(hex: "#6213D0"))
                .cornerRadius(10)
            }
            Button(action: {
                if flashCardIndex < studySetVM.currentlyChosenStudySet.flashcards.count - 1 {
                    flashCardIndex += 1
                    showBack = false
                }
            }) {
                HStack {
                    Text("Next")
                    Image(systemName: "arrow.right")
                }
                .padding()
                .foregroundColor(.white)
                .background(Color(hex: "#6213D0"))
                .cornerRadius(10)
            }
        }
    }
}
struct StudyView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleFlashcards = [
            FlashcardModel(front: "Hello", back: "World", createdBy: "Calvin", mastered: false),
            FlashcardModel(front: "Swift", back: "UI", createdBy: "Calvin", mastered: false),
            FlashcardModel(front: "SwiftUI", back: "Is awesome", createdBy: "Calvin", mastered: false)
        ]
        let sampleStudySet = StudySetModel(flashcards: sampleFlashcards, dateCreated: Date(), createdBy: "Calvin")

        let sampleVM = StudySetViewModel.shared
        sampleVM.currentlyChosenStudySet = sampleStudySet
        return StudyView(studySetVM: sampleVM)
    }
}
