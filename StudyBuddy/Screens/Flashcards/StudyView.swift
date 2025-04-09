//
//  StudyView.swift
//  StudyBuddy
//
//  Created by Jihoon Kim on 2/11/25.
//

import SwiftUI
// test flashcards
var flashcard1: FlashcardModel = FlashcardModel(
    front: "What is Swift?",
    back: "A high-level, interpreted programming language",
    createdBy: "Jihoon Kim",
    mastered: false
)
var flashcard2: FlashcardModel = FlashcardModel(
    front: "Why use swift?",
    back: "because it is interpreted programming language",
    createdBy: "Sean Yan",
    mastered: false
)

var flashcard3: FlashcardModel = FlashcardModel(
    front: "How to use swift?",
    back: "use the interpreted programming language",
    createdBy: "Sean Yan",
    mastered: false
)

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

struct StudyView: View {
    @State var studySet: [FlashcardModel] = [flashcard1, flashcard2, flashcard3]
    @State private var flashCardIndex = 0
    @State private var showBack = true
    @State private var master: Int = 0
    @State private var unmaster: Int = 0
    @State private var dragOffset = CGSize.zero // for rectangle dragging

    
    
    init(studySet: [FlashcardModel] = [flashcard1, flashcard2, flashcard3]) {
        _studySet = State(initialValue: studySet)
    }
    
    
    var body: some View {
        VStack {
            topNavView()
            topStatusView()
            Spacer()
            cardView()
            Spacer()
            navBar()
            Spacer()
        }
        .onAppear {
            updateMaster()
        }
    }

    private func topNavView() -> some View {
        HStack {
            Button(action: {
                // needs to be completed
                print("return")
            }) {
                Image(systemName: "xmark")
            }
            Spacer()
            Text("\(flashCardIndex)/\(studySet.count)")
                .font(.headline)
            Spacer()
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 10)
    }

    private func topStatusView() -> some View {
        HStack {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 5)
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.blue)
                    .frame(width: getProgress() * 400, height: 6)
            }
        }
    }

    private func cardView() -> some View {
        ZStack {
            // if theres a next card, have a next card
            if let nextCard = studySet[safe: flashCardIndex + 1] {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.blue)
                    .frame(width: 375, height: 600)
                    .shadow(radius: 5)
                    .overlay(
                        Text(showBack ? nextCard.front : nextCard.back)
                            .font(.title)
                            .foregroundColor(.black)
                    )

            }

            // draggable top card
            if let currentCard = studySet[safe: flashCardIndex] {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.blue)
                    .frame(width: 375, height: 600)
                    .shadow(radius: 5)
                    .overlay(
                        Text(showBack ? currentCard.front : currentCard.back)
                            .font(.title)
                            .foregroundColor(.black)
                    )
                    .offset(x: dragOffset.width)
                    // no idea what this code is for, helps with animation glitches when u swipe the card off the screen
                    .id(flashCardIndex)
                    .transition(.asymmetric(
                        insertion: .identity,
                        removal: .move(edge: dragOffset.width > 0 ? .trailing : .leading)))
                    
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation
                            }
                            .onEnded { _ in
                                if abs(dragOffset.width) > 225 {
                                    // push card off of screen if threshold reached
                                    withAnimation(.spring()) {
                                        dragOffset.width = dragOffset.width > 0 ? 1000 : -1000
                                    }
                                    //  update counters for mastered/struggled
                                    if dragOffset.width > 0 {
                                        studySet[flashCardIndex].mastered = true
                                        
                                        
                                    } else {
                                        studySet[flashCardIndex].mastered = false
                                    }
                                
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                        flashCardIndex += 1
                                        dragOffset = .zero
                                        showBack = true
                                        updateMaster()
                                        
                                                                            }
                                    
                                } else {
                                    // bring back to center
                                    withAnimation(.spring()) {
                                        dragOffset = .zero
                                    }
                                }
                            }
                    )
                    .onTapGesture {
                        showBack.toggle()
                    }
            }
        }
    }

    private func navBar() -> some View {
        HStack {
            
            ZStack {
                HStack {
                    UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 20, topTrailingRadius: 20)
                        .fill(Color.red)
                        .frame(width: 100, height: 60)
                        .shadow(radius: 5)
                }
//                Image(systemName: "xmark.seal")
                Text("\(unmaster)")
            }
            
            Spacer()
            HStack {
                Button(action: {
                    // go back one card, and flip to front
                    if (flashCardIndex > 0) {
                        flashCardIndex -= 1
                    }
                    showBack = true
                }) {
                    HStack {
                        Image(systemName: "return")
                    }
                }
            }
            
            Spacer()
            ZStack {
                HStack {
                    UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 20, bottomTrailingRadius: 0, topTrailingRadius: 0)
                        .fill(Color.green)
                        .frame(width: 100, height: 60)
                        .shadow(radius: 5)
                }
                
//                Image(systemName: "checkmark.seal")
                Text("\(master)")
            }
            
            
            
        }
    }
    private func getProgress() -> Double {
        return Double(flashCardIndex) / Double(studySet.count)
    }
    private func updateMaster() -> Void {
        let mastered = studySet.filter { $0.mastered }.count
        self.master = mastered
        self.unmaster = studySet.count - mastered
    }
}

#Preview {
    StudyView()
}
