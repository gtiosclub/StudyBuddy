// import SwiftUI
// Features:
// - swipe to delete
// - Still need to add chatbot link for button
// - pencil and then swipe to edit (brings up the same popup as add but populated with current text
// - add icons for fcards, chatbot, and documents
// - viewmodel shit

import SwiftUI

struct SetView: View {
    @StateObject var studySetVM: StudySetViewModel = StudySetViewModel.shared
    @State private var frontText: String = ""
    @State private var backText: String = ""
    @State private var filteredText: String = ""
    @State private var frontEditText: String = ""
    @State private var backEditText: String = ""
    @State private var flashcardToEdit: FlashcardModel? = nil
    @State private var showAddCard: Bool = false
    var body: some View {
        ZStack {
            // Main Content
            NavigationStack {
                VStack(alignment: .center, spacing: 15) {
                    topOfPage()
                    fcardButton()
                    chatBotButton()
                    viewFilesButton()
                    fcardDisplay()
                }
                .background(Color("setViewBackground"))
            }

            if let flashcard = flashcardToEdit {
                Color.black.opacity(0.3) // Dim background.
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    Text("Edit Flashcard")
                        .font(.headline)
                        .padding(.top, 12)

                    TextField("Term", text: $frontEditText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    TextField("Definition", text: $backEditText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button(action: {
                        if !frontEditText.isEmpty && !backEditText.isEmpty {
                            studySetVM.editFlashcard(flashcard: flashcard,
                                                     newFront: frontEditText,
                                                     newBack: backEditText)
                            withAnimation {
                                flashcardToEdit = nil
                            }
                        }
                    }) {
                        Text("Save")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical, 20)
                .background(Color("calvinColor"))
                .cornerRadius(15)
                .frame(maxWidth: 300) // Reduced width.
                .shadow(radius: 8)
                .transition(.scale)
            }
            if showAddCard {
                Color.black.opacity(0.3) // Dim background.
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    Text("Add Flashcard")
                        .font(.headline)
                        .padding(.top, 12)

                    TextField("Term", text: $frontText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    TextField("Definition", text: $backText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button(action: {
                        if !frontText.isEmpty && !backText.isEmpty {
                            studySetVM.addFlashcard(front: frontText, back: backText)
                            withAnimation {
                                showAddCard = false
                            }
                        }
                    }) {
                        Text("Add")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical, 20)
                .background(Color("calvinColor"))
                .cornerRadius(15)
                .frame(maxWidth: 300) // Reduced width.
                .shadow(radius: 8)
                .transition(.scale)
            }
        }
        
    }

    private func topOfPage() -> some View {
        VStack {
            HStack {
                Text(studySetVM.getUser())
                    .foregroundColor(Color("calvinColor"))
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            HStack {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)
                Text(studySetVM.getUser())
                    .foregroundColor(Color("calvinColor"))
                    .font(.headline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 25)
        }
    }

    private func fcardButton() -> some View {
        VStack {
            HStack {
                NavigationLink(destination: StudyView(/*studySetVM: studySetVM*/)) {
                    HStack(spacing: 4) {  // Spacing between image and text.
                        Image("cardsImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .padding(.horizontal, 15)

                        Text("Study")
                            .font(.title3)
                            .foregroundColor(Color("calvinColor"))
                            .padding(.vertical, 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("cardColor"))
                    .cornerRadius(30)
                }
                .padding(.horizontal, 20)
            }
        }
    }

    private func chatBotButton() -> some View {
        VStack {
            HStack {
                NavigationLink(destination: ChatInterfaceView()) {
                    HStack(spacing: 4) {  // Spacing between image and text.
                        Image("chatBotImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .padding(.horizontal, 15)

                        Text("Chatbot")
                            .font(.title3)
                            .foregroundColor(Color("calvinColor"))
                            .padding(.vertical, 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("cardColor"))
                    .cornerRadius(30)
                }
                .padding(.horizontal, 20)
            }
        }
    }

    private func viewFilesButton() -> some View {
        VStack {
            HStack {
                NavigationLink(destination: StudyView(/*studySetVM: studySetVM*/)) {
                    HStack(spacing: 4) {  // Spacing between image and text.
                        Image("filesImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .padding(.horizontal, 15)

                        Text("View Files")
                            .font(.title3)
                            .foregroundColor(Color("calvinColor"))
                            .padding(.vertical, 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("cardColor"))
                    .cornerRadius(30)
                }
                .padding(.horizontal, 20)
            }
        }
    }

    private func fcardDisplay() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("__Set Terms (\(studySetVM.currentlyChosenStudySet.flashcards.count))__")
                    .padding(.horizontal, 20)
                    .font(.title2)
                    .foregroundColor(Color("calvinColor"))
                Button(action: {
                    frontText = ""
                    backText = ""
                    showAddCard = true
                }) {
                    Text("+")
                        .foregroundColor(Color("calvinColor"))
                        .font(.title)
                        .padding(.leading, 160)
                }
            }

            HStack(spacing: 0) {
                Text("\u{1F50D}")
                    .padding(5)
                TextField("", text: $filteredText)
                    .foregroundColor(.black)
                    .background(Color("blah"))
                    .padding(.horizontal, 10)
            }
            .background(RoundedRectangle(cornerRadius: 80).fill(Color("blah")))
            .padding(.horizontal, 20)

            ScrollView {
                VStack(spacing: 8) {
                    let flashcardsToDisplay = filteredText.isEmpty ?
                        studySetVM.currentlyChosenStudySet.flashcards :
                        studySetVM.currentlyChosenStudySet.flashcards.filter { flashcard in
                            let combinedText = flashcard.front + flashcard.back
                            return combinedText.lowercased().contains(filteredText.lowercased())
                        }

                    ForEach(flashcardsToDisplay) { flashcard in
                        SwipeAction(cornerRadius: 8, direction: .trailing) {
                            flashcardCell(flashcard)
                        } actions: {
                            // Edit action
                            Action(tint: .blue, icon: "pencil") {
                                frontEditText = flashcard.front
                                backEditText = flashcard.back
                                flashcardToEdit = flashcard
//                                print("Edit flashcard: \(flashcard.id)")
                            }
                            Action(tint: .red, icon: "trash.fill") {
                                withAnimation {
                                    studySetVM.deleteFlashcard(flashcard)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color(hex: "#321C58").edgesIgnoringSafeArea(.all))
        }
    }

    @ViewBuilder
    private func flashcardCell(_ flashcard: FlashcardModel) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(flashcard.front)
                .font(.headline)
                .foregroundColor(Color("calvinColor"))
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(flashcard.back)
                .font(.subheadline)
                .foregroundColor(Color("calvinColor"))
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.gray)
        .cornerRadius(8)
    }

}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        SetView()
//        Calv()
    }
}
////Custom swipe action view
struct SwipeAction<Calv: View>: View {
    var cornerRadius: CGFloat = 0
    var direction: SwipeDirection = .trailing
    @ViewBuilder var content: Calv
    @ActionBuiler var actions: [Action]
    let viewID = UUID()
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    content
                    // to take up the full availabel space
                        .containerRelativeFrame(.horizontal)
                        .background {
                            if let firstAction = actions.first {
                                Rectangle().fill(firstAction.tint)
                            }
                        }.id(viewID)

                    actionButtons()

                }
                .scrollTargetLayout()
                .visualEffect   {
                    content, geometryProxy in
                    content.offset(x: scrollOffset(geometryProxy))
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .background {
                if let lastAction = actions.last {
                    Rectangle()
                        .fill(lastAction.tint)
                }
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
        }
    }
    @ViewBuilder
    func actionButtons() -> some View {
        Rectangle()
            .fill(.clear)
            .frame(width: CGFloat(actions.count) * 100)
            .overlay(alignment: direction.alignment) {
                HStack(spacing: 0) {
                    ForEach(actions) { button in
                        Button(action: {
                            withAnimation {
                            button.action()
                        }}, label: {
                            Image(systemName: button.icon)
                                .font(button.iconFont)
                                .foregroundStyle(button.iconTint)
                                .frame(width: 100)
                                .frame(maxHeight: .infinity)
                                .contentShape(.rect)
                        })
                        .buttonStyle(.plain)
                        .background(button.tint)
                    }
                }
            }

    }
    
    func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        return direction == .trailing ? (minX > 0 ? -minX : 0) : (minX < 0 ? -minX : 0)
    }
}

// Swipe Direction
enum SwipeDirection {
    case leading
    case trailing

    var alignment: Alignment {
        switch self {
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        }
    }
}
struct Action: Identifiable {
    private(set) var id: UUID = .init()
    var tint: Color
    var icon: String
    var iconFont: Font = .title
    var iconTint: Color = .white
    var isEnabled: Bool = true
    var action: () -> ()
}
@resultBuilder
struct ActionBuiler {
    static func buildBlock(_ components: Action...) -> [Action]{
        return components
    }
}
