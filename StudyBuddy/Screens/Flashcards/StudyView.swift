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

extension Color {
    static let background = Color(red: 50/255, green: 28/255, blue: 88/255)
    static let purpleLight = Color(red: 103/255, green: 78/255, blue: 144/255)
    static let purpleGrey = Color(red: 233/255, green: 221/255, blue: 255/255)
}

struct StudyView: View {
    @State var studySet: [FlashcardModel] = [flashcard1, flashcard2, flashcard3]
    //@StateObject private var studySetViewmodel: StudySetViewModel
    @State private var flashCardIndex = 0
    @State private var showBack = true
    @State private var master: Int = 0
    @State private var unmaster: Int = 0
    @State private var dragOffset = CGSize.zero // for rectangle dragging
    @Environment(\.dismiss) var dismiss
    
    /*init(studySetViewmodel: StudySetViewModel) {
        self.studySetViewmodel = studySetViewmodel
    }*/
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
                .allowsHitTesting(false)
            VStack {
                topNavView()
                topStatusView()
                Spacer()
                cardView()
                Spacer()
                navBar()
                Spacer()
            }
            .foregroundColor(Color.purpleGrey)
            .onAppear {
                updateMaster()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
        }
    }
        
        
        

    private func topNavView() -> some View {
        HStack {
            Button(action: {
                dismiss()
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
                    .fill(Color.purpleLight)
                    .frame(height: 5)
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.purpleGrey)
                    .frame(width: getProgress() * 400, height: 6)
            }
        }
    }

    private func cardView() -> some View {
        ZStack {
            // if theres a next card, have a next card
            if let nextCard = studySet[safe: flashCardIndex + 1] {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.purpleLight)
                    .frame(width: 375, height: 600)
                    .shadow(radius: 5)
                    .overlay(
                        Text(showBack ? nextCard.front : nextCard.back)
                            .font(.title)
                    )

            }

            // draggable top card
            if let currentCard = studySet[safe: flashCardIndex] {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.purpleLight)
                    .frame(width: 375, height: 600)
                    .shadow(radius: 5)
                    .overlay(
                        Text(showBack ? currentCard.front : currentCard.back)
                            .font(.title)
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
                    UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 40, topTrailingRadius: 40)
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
                    UnevenRoundedRectangle(topLeadingRadius: 40, bottomLeadingRadius: 40, bottomTrailingRadius: 0, topTrailingRadius: 0)
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

struct ProgressBarView: View {
    let termsMastered: Int
    let totalTerms: Int
    
    var progressValue: Double {
        Double(termsMastered) / Double(totalTerms)
    }

    var percentageValue: Int {
        Int(progressValue * 100)
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Your Progress")
                    .font(.headline)
                    .foregroundColor(Color(.darkGray))
                    
                HStack(spacing: 0) {
                    Text("\(percentageValue)")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(Color(.white))
                        .padding(.bottom, 5)
                    
                    Text("%")
                        .font(.system(size: 80))
                        .foregroundColor(Color(.white))
                }

                Text("\(termsMastered)/\(totalTerms) terms mastered")
                    .font(.subheadline)
                    .foregroundColor(Color(.darkGray))
                    .padding(.bottom, 8)

                ProgressView(value: progressValue)
                    .progressViewStyle(LinearProgressViewStyle())
                    .tint(Color.gray)
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                    .padding(.bottom, 8)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray4)))
            .padding()
        }
    }
}

#Preview {
    StudyView()
}
