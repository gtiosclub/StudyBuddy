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
    @State private var sortOption: SortOption = .popularity
    @EnvironmentObject var studySetViewModel: StudySetViewModel

    enum SortOption: String, CaseIterable {
        case popularity = "Popularity"
        case dateCreated = "Date Created"
    }

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
                        if (!searchText.isEmpty) {
                            recentSearches.insert(searchText, at: 0)
                            if (recentSearches.count > 10) {
                                recentSearches.removeLast()
                            }
                            searchText = ""
                        }
                    })
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)

                    if (isSearching) {
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

                if (isSearching) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Recent Searches")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(showAllSearches ? recentSearches : Array(recentSearches.prefix(5)), id: \.self) { search in
                            Button(action: {
                                searchText = search
                                isSearching = false
                            }) {
                                Text(search)
                                    .padding(.horizontal)
                                    .foregroundColor(.gray)
                            }
                        }

                        if (recentSearches.count > 5 && !showAllSearches) {
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

                        if (showAllSearches) {
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
                            if studySetViewModel.studySets.count > 0 {
                                ForEach(studySetViewModel.studySets.prefix(5)) { set in
                                    VStack(spacing: 0) {
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(set.name)
                                                .font(.headline)

                                            HStack(spacing: 8) {
                                                Circle()
                                                    .fill(Color.white.opacity(0.3))
                                                    .frame(width: 20, height: 20)
                                                Text(set.createdBy)
                                                    .foregroundColor(.black)
                                                    .font(.subheadline)
                                            }

                                            Text("\(set.flashcards.count) terms")
                                                .font(.subheadline)
                                                .foregroundColor(.black)

                                            Spacer().frame(height: 6)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding()

                                        Divider()

                                        HStack(spacing: 0) {
                                            NavigationLink(destination: ChatInterfaceView(set: set)) {
                                                Text("Chatbot")
                                                    .font(.subheadline)
                                                    .bold()
                                                    .frame(maxWidth: .infinity)
                                                    .padding()
                                                    .foregroundColor(.black)
                                            }

                                            Rectangle()
                                                .frame(width: 1, height: 33)
                                                .foregroundColor(.gray.opacity(0.6))

                                            NavigationLink(destination: SetView().onAppear {
                                                studySetViewModel.currentlyChosenStudySet = set
                                            }) {
                                                Text("Flashcards")
                                                    .font(.subheadline)
                                                    .bold()
                                                    .frame(maxWidth: .infinity)
                                                    .padding()
                                                    .foregroundColor(.black)
                                            }
                                        }
                                        .background(Color.white.opacity(0.5))
                                    }
                                    .background(Color.gray.opacity(0.8))
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            } else {
                                Text("No Sets")
                            }
                        }
                        .padding(.top)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                studySetViewModel.listenToUserDocuments()
            }
        }
    }
}
