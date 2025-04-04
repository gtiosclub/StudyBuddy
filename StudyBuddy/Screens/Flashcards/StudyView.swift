//
//  StudyView.swift
//  StudyBuddy
//
//  Created by Jihoon Kim on 2/11/25.
//

import SwiftUI

struct StudyView: View {
    let hardcodedSet: [(String, String)] = [("Hello", "World"), ("Swift", "UI"), ("SwiftUI", "Is")]
    @ObservedObject var studySet: StudySet
    @State private var flashCardIndex = 0
    @State private var showBack = false
    @State private var currentText: String = ""
    @State private var progress: Double = 0.4 // controls status bar
    @State private var master: Int = 0
    @State private var unmaster: Int = 0
    @State private var dragOffset = CGSize.zero // for rectangle dragging

    init(studySet: StudySet) {
        self.studySet = studySet
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
    }

    private func topNavView() -> some View {
        HStack {
            Button(action: {
                print("return") // go back not implemented yet
            }) {
                HStack {
                    Image(systemName: "xmark")
                }
            }
            
            Spacer()
            Text("14/48") // actual progress not implemented yet
                .font(.headline)
            Spacer()
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 10)
    }

    private func topStatusView() -> some View {
        HStack {
            VStack {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.gray)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 5)
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.blue)
                        .frame(width: (progress * 400), height: 6)
                }
            }
        }
    }

    private func cardView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.green)
                .frame(width: 175, height: 600)
                .shadow(radius: 5)
                .overlay(
                    Text("Mastered")
                )
                .offset(x: dragOffset.width - 350, y: 0) // makes the rectangle outside the user view
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.red)
                .frame(width: 175, height: 600)
                .shadow(radius: 5)
                .overlay(
                    Text("Not Mastered")
                )
                .offset(x: dragOffset.width + 350, y: 0) // makes the rectangle outside the user view
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue)
                .frame(width: 375, height: 600)
                .shadow(radius: 5)
                .overlay(
                    Text((showBack ? studySet.set["\(flashCardIndex)"]?.1 ?? "back" : studySet.set["\(flashCardIndex)"]?.0) ?? "front")
                        .font(.title)
                        .foregroundColor(.black)
                )
                .offset(x: dragOffset.width)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation
                        }
                        .onEnded { value in
                            withAnimation(.spring()) {
                                // makes sure drag is not too out of bounds
                                dragOffset.width = min(max(dragOffset.width, -260), 260)

                                if dragOffset.width > 250 {
                                    // implementation for mastering term
                                    print("right")
                                    master += 1 // call model
                                    flashCardIndex += 1
                                } else if dragOffset.width < -250 {
                                    // implementation for struggling term
                                    print("left")
                                    unmaster += 1 // call model
                                    flashCardIndex += 1
                                }
                                

                                // Smoothly reset the drag offset with animation
                                dragOffset = .zero
                            }
                        }
                )
                .onTapGesture {
                    showBack.toggle()
                }
        }
    }

    private func navBar() -> some View {
        HStack {
            HStack {
                Image(systemName: "checkmark.seal")
                Text("\(master)")
            }

            HStack {
                Image(systemName: "xmark.seal")
                Text("\(unmaster)")
            }

            Spacer()

            Button(action: {
                showBack.toggle()
            }) {
                HStack {
                    Image(systemName: "return")
                    Text("Undo")
                }
            }
        }
        .padding(20)
    }
}

#Preview {
    StudyView(studySet: StudySet(set: ["1":("Hello","World"), "2":("Swift","UI"), "3":("SwiftUI","booo"), "4":("Card","definition"), "5":("Onemore","card")]))
}
