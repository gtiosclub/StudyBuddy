//
//  SearchView.swift
//  StudyBuddy
//
//  Created by Joseph Masson on 4/3/25.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    @State private var recentSearches: [String] = ["CS2200", "MATH1554", "CS1332", "CS3240", "CS4400"]
    @State private var showAllSearches: Bool = false
    private var trendingSets: [String] = [
        "CS2200 Exam 1",
        "CS1332 Exam 2",
        "MATH1554 Review",
        "CS3240 Midterm",
        "CS4400 Final Exam"
    ]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Search")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)

                HStack {
                    TextField("Search...", text: $searchText, onEditingChanged: { isEditing in
                        isSearching = isEditing
                    }, onCommit: {
                        if !searchText.isEmpty {
                            recentSearches.insert(searchText, at: 0)
                            if recentSearches.count > 10 { // Limit recent searches to 10
                                recentSearches.removeLast()
                            }
                            searchText = ""
                            isSearching = false
                        }
                    })
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)

                    if isSearching {
                        Button(action: {
                            searchText = ""
                            isSearching = false
                        }) {
                            Text("Cancel")
                                .foregroundColor(.blue)
                        }
                        .padding(.trailing)
                    }
                }

                if isSearching {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Recent Searches")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(showAllSearches ? recentSearches : Array(recentSearches.prefix(5)), id: \.self) { search in
                            Text(search)
                                .padding(.horizontal)
                                .foregroundColor(.gray)
                        }

                        if recentSearches.count > 5 && !showAllSearches {
                            Button(action: {
                                showAllSearches.toggle()
                            }) {
                                Text("Show More")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                            }
                        }

                        if showAllSearches {
                            Button(action: {
                                recentSearches.removeAll()
                                showAllSearches = false
                            }) {
                                Text("Clear History")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                } else {
                    Text("Recently Trending")
                        .font(.headline)
                        .padding(.horizontal)

                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(trendingSets, id: \.self) { set in
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 100)
                                    .overlay(
                                        HStack {
                                            Circle()
                                                .fill(Color.gray)
                                                .frame(width: 30, height: 30)
                                            Text(set)
                                                .font(.headline)
                                                .foregroundColor(.gray)
                                            Spacer()
                                        }
                                        .padding()
                                    )
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}
