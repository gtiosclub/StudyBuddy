//
//  SetView.swift
//  StudyBuddy
//
//  Created by Jihoon Kim on 2/11/25.
//

import SwiftUI

struct SetView: View {
    var hardcodedSet: [String: String] = ["Hello": "World", "Swift": "UI", "SwiftUI": "Is", "Card": "definition", "Onemore": "card"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Flashcards")
                        .font(.title)
                        .padding()
                    
                    ForEach(hardcodedSet.keys.sorted(), id: \.self)
                    { key in
                        HStack { // Loops through the flashcards from hardcodedSet and adds them to the scrollable views
                            Text(key)
                                .font(.headline)
                            Spacer()
                            Text(hardcodedSet[key] ?? "")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                    }

                }
                .safeAreaInset(edge: .bottom) { // Idea was to pin the button to the bottom but it isnt doing that
                    NavigationLink(destination: StudyView()) {
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
}
// Next to do: Add button that takes you to study view from this one.

#Preview {
SetView()
}












//
    //    var body: some View {
    //        Text("View All the Words")
    //    }
    //}
    //
    //#Preview {
    //    SetView()
    //}
