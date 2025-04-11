//
//  StudyView.swift
//  StudyBuddy
//
//  Created by Jihoon Kim on 2/11/25.
//

import SwiftUI

struct StudyView: View {
    @ObservedObject var studySet: StudySet
    @State private var flashCardIndex = 0
    @State private var showBack = false

    init(studySet: StudySet) {
        self.studySet = studySet
    }

    var body: some View {
        VStack {
            Spacer()
            Spacer()
            cardView()
            Spacer()
            navBar()
            Spacer()
        }
        .padding()
        .background(Color(hex: "#321C58").edgesIgnoringSafeArea(.all))
    }

    private func cardView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "#71569E"))
                .frame(width: 300, height: 200)
                .shadow(radius: 5)

            Text(
                (showBack
                 ? studySet.set["\(flashCardIndex)"]?.1 ?? "back"
                 : studySet.set["\(flashCardIndex)"]?.0 ?? "front")
            )
            .font(.title)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding()
        }
        .onTapGesture {
            showBack.toggle()
        }
    }

    private func navBar() -> some View {
        HStack(spacing: 40) {
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
                if flashCardIndex < studySet.set.count - 1 {
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

#Preview {
    StudyView(
        studySet: StudySet(set: [
            "0": ("Hello", "World"),
            "1": ("Swift", "UI"),
            "2": ("SwiftUI", "booo"),
            "3": ("Card", "definition"),
            "4": ("Onemore", "card")
        ])
    )
}
