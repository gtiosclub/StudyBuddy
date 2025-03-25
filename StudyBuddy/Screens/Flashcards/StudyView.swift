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

    }
    private func cardView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue)
                .frame(width: 300, height: 200)
                .shadow(radius: 5)
            Text((showBack ? studySet.set["\(flashCardIndex)"]?.1 ?? "back" : studySet.set["\(flashCardIndex)"]?.0) ?? "front")
                    .font(.title)
        }
        .onTapGesture {
            showBack.toggle()
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
                if flashCardIndex < studySet.set.count {

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
    StudyView(studySet: StudySet(set: ["1":("Hello","World"), "2":("Swift","UI"), "3":("SwiftUI","booo"), "4":("Card","definition"), "5":("Onemore","card")]))
}
