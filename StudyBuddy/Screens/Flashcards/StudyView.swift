//
//  StudyView.swift
//  StudyBuddy
//
//  Created by Jihoon Kim on 2/11/25.
//

import SwiftUI

struct StudyView: View {
    let hardcoded_set: [(String, String)] = [("Hello", "World"), ("Swift", "UI"), ("SwiftUI", "Is")]

    @State private var flashCardIndex = 0
    @State private var showBack = false
    @State private var currentText: String = ""
    var body: some View {
        VStack {
            Spacer()
            Text("FlashCard Mockup")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
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
            Text(showBack ? hardcoded_set[flashCardIndex].1 : hardcoded_set[flashCardIndex].0)
                    .font(.title)
        }
        .onTapGesture {
            showBack.toggle()
        }

    }
    private func navBar() -> some View {
        HStack {
            
            Button(action: {
                if (flashCardIndex > 0) {
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
                if (flashCardIndex < hardcoded_set.count - 1) {
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
    StudyView()
}
