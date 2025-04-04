// What I need to do:
// 1) Name of Studyset at the top of the screen
// 2) Username under that with profile pic placeholder
// 3) Progress/Mastery bar (Not my job, already done)
// 4) Terms appearing as their front spacer() back in a card
// 5) Able to swipe and delete cards
// 6) Searchbar to filter them

import SwiftUI

struct SetView: View {
    @StateObject var studySet: StudySetModel = StudySetModel(
        flashcards: [
        ],
        dateCreated: Date(),
        createdBy: "User"
    )
    var body: some View {
        NavigationStack {
            topOfPage()
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(studySet.flashcards) { flashcard in
                        HStack {
                            Text(flashcard.front)
                                .font(.headline)
                            Spacer()
                            Text(flashcard.back)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    NavigationLink(destination: StudyView(studySet: studySet)) {
                        Text("Study")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
        }
    }
    private func topOfPage() -> some View {
        VStack {
            HStack { // this is for the name of set and the 3 dots to 
                Text("Study Set")
                    .font(.title)
                    .padding()
                NavigationLink(destination: AddView(studySet: studySet)) {
                    Text("+")
                }
            }

        }
    }
}

#Preview {
    SetView()
}
