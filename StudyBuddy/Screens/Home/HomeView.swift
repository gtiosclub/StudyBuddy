//
//  HomeView.swift
//  StudyBuddy
//
//  Created by Tejeshwar Natarajan on 2/6/25.
//

import SwiftUI

struct ContentView: View {
    // Mapping class ID to its description
    @State var widgets: [String: String] = [
        "2200": "A broad exposure to computer system structure and networking including software abstractions in operating systems for orchestrating the usage of the computing resources.",
        "1332": "Computer data structures and algorithms in the context of object-oriented programming. Focus on software development towards applications.",
        "1554": "Linear Algebra, Linear algebra eigenvalues, eigenvectors, applications to linear systems, least squares, diagnolization, quadratic forms."]
    @State private var expandedDescriptions: Set<String> = []
    var body: some View {
        VStack(alignment: .leading) {
            Text("StuddyBuddy")
                .font(.headline)
                .padding(.vertical)
            ForEach(widgets.keys.sorted(), id: \.self) { key in
                VStack(alignment: .leading, spacing: 5) {
                    Button(action: {
                        withAnimation {
                            if expandedDescriptions.contains(key) {
                                expandedDescriptions.remove(key)
                            } else {
                                expandedDescriptions.insert(key)
                            }
                        }
                    }) {
                        VStack {
                            HStack {
                                Text(key)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "circle")
                                    .foregroundColor(.white)
                                Image(systemName: "circle")
                                    .foregroundColor(.white)
                            }
                            Text(widgets[key] ?? "No Description")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxHeight: 20)

                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(10)
                    }
                    
                    // class desc
                    if expandedDescriptions.contains(key) {
                        Text(widgets[key] ?? "No Description")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            Spacer()
        }
        .padding()
    }
}
