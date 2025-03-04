//
//  SetView.swift
//  StudyBuddy
//
//  Created by Jihoon Kim on 2/11/25.
//

import SwiftUI

struct SetView: View {
    @ObservedObject var exampleSet: StudySet = StudySet(set: ["1":("print","Prints to console"), "2":("SwiftUI","Used to create UI"), "3":("Firebase","Stores information")])
    var hardcodedSet: [String: String] = ["Hello": "World", "Swift": "UI", "SwiftUI": "booo", "Card": "definition", "Onemore": "card"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Study Set 1")
                            .font(.title)
                            .padding()
                        NavigationLink(destination: AddView(studySet: exampleSet)) {
                            Text("+")
                        }
                    }
                    ForEach(exampleSet.set.keys.sorted(), id: \.self) { key in
                        let value = exampleSet.set[key]!
                        HStack { // Loops through the flashcards from hardcodedSet and adds them to the scrollable views
                            Text(value.0)
                                .font(.headline)
                            Spacer()
                            Text(value.1)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                    }

                }
                .safeAreaInset(edge: .bottom) { // Idea was to pin the button to the bottom but it isnt doing that
                    NavigationLink(destination: StudyView(studySet: exampleSet)) {
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

