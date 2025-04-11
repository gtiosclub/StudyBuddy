//
//  SetView.swift
//  StudyBuddy
//
//  Created by Jihoon Kim on 2/11/25.
//

import SwiftUI

struct SetView: View {
    @ObservedObject var exampleSet: StudySet = StudySet(set: [
        "1": ("print", "Prints to console"),
        "2": ("SwiftUI", "Used to create UI"),
        "3": ("Firebase", "Stores information")
    ])
    
    var hardcodedSet: [String: String] = [
        "Hello": "World",
        "Swift": "UI",
        "SwiftUI": "booo",
        "Card": "definition",
        "Onemore": "card"
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Study Set 1")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()

                        NavigationLink(destination: AddView(studySet: exampleSet)) {
                            Text("+")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color(hex: "#71569E"))
                                .cornerRadius(6)
                        }
                    }

                    ForEach(exampleSet.set.keys.sorted(), id: \.self) { key in
                        let value = exampleSet.set[key]!
                        HStack {
                            Text(value.0)
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            Text(value.1)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding()
                        .background(Color(hex: "#71569E"))
                        .cornerRadius(8)
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    NavigationLink(destination: StudyView(studySet: exampleSet)) {
                        Text("Study")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "#6213D0"))
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
            .background(Color(hex: "#321C58").edgesIgnoringSafeArea(.all))
        }
    }
}

#Preview {
    SetView()
}
