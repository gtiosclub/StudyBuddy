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
    @State private var filteredSets: [StudySetModel] = []
    @EnvironmentObject var studySetViewModel: StudySetViewModel

    enum SortOption: String, CaseIterable {
        case popularity = "Popularity"
        case dateCreated = "Date Created"
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#321C58").ignoresSafeArea()

                VStack(alignment: .leading, spacing: 16) {
                    Text("Search")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal)

                    HStack {
                        TextField("Search...", text: $searchText, onEditingChanged: { isEditing in
                            isSearching = isEditing
                        }, onCommit: {
                            performSearch()
                        })
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .foregroundStyle(.white)

                        if isSearching {
                            Button(action: {
                                clearSearch()
                            }) {
                                Text("Cancel")
                                    .foregroundColor(.white)
                            }
                            .padding(.trailing)
                        }
                    }

                    if isSearching {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Recent Searches")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)

                            ForEach(showAllSearches ? recentSearches : Array(recentSearches.prefix(5)), id: \.self) { search in
                                Button(action: {
                                    searchText = search
                                    performSearch()
                                }) {
                                    Text(search)
                                        .padding(.horizontal)
                                        .foregroundColor(.white)
                                }
                            }

                            if recentSearches.count > 5 && !showAllSearches {
                                Button(action: {
                                    showAllSearches.toggle()
                                }) {
                                    Text("Show More")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
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
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    } else {
                        if !filteredSets.isEmpty {
                            ScrollView {
                                VStack(spacing: 12) {
                                    ForEach(filteredSets) { set in
                                        VStack(spacing: 0) {
                                            VStack(alignment: .leading, spacing: 6) {
                                                Text(set.name)
                                                    .font(.headline)
                                                    .foregroundColor(.white)

                                                HStack(spacing: 8) {
                                                    Circle()
                                                        .fill(Color.white.opacity(0.3))
                                                        .frame(width: 20, height: 20)
                                                    Text(set.createdBy)
                                                        .foregroundColor(.white)
                                                        .font(.subheadline)
                                                }

                                                Text("\(set.flashcards.count) terms")
                                                    .font(.subheadline)
                                                    .foregroundColor(.white)

                                                Spacer().frame(height: 6)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding()

                                            Divider().background(Color.white.opacity(0.3))

                                            HStack(spacing: 0) {
                                                NavigationLink(destination: ChatInterfaceView(set: set)) {
                                                    Text("Chatbot")
                                                        .font(.subheadline)
                                                        .bold()
                                                        .frame(maxWidth: .infinity)
                                                        .padding()
                                                        .foregroundColor(.white)
                                                        .background(Color(hex: "#6213D0"))
                                                }

                                                NavigationLink(destination: SetView().onAppear {
                                                    studySetViewModel.currentlyChosenStudySet = set
                                                }) {
                                                    Text("Flashcards")
                                                        .font(.subheadline)
                                                        .bold()
                                                        .frame(maxWidth: .infinity)
                                                        .padding()
                                                        .foregroundColor(.white)
                                                        .background(Color(hex: "#6213D0"))
                                                }
                                            }
                                        }
                                        .background(Color(hex: "#71569E"))
                                        .cornerRadius(12)
                                        .padding(.horizontal)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                .padding(.top)
                            }
                        } else if !searchText.isEmpty {
                            Text("No Results Found")
                                .foregroundColor(.white)
                                .padding(.horizontal)
                        } else {
                            Text("Recently Trending")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)

                            ScrollView {
                                VStack(spacing: 12) {
                                    if studySetViewModel.studySets.count > 0 {
                                        ForEach(studySetViewModel.studySets.prefix(5)) { set in
                                            VStack(spacing: 0) {
                                                VStack(alignment: .leading, spacing: 6) {
                                                    Text(set.name)
                                                        .font(.headline)
                                                        .foregroundColor(.white)

                                                    HStack(spacing: 8) {
                                                        Circle()
                                                            .fill(Color.white.opacity(0.3))
                                                            .frame(width: 20, height: 20)
                                                        Text(set.createdBy)
                                                            .foregroundColor(.white)
                                                            .font(.subheadline)
                                                    }

                                                    Text("\(set.flashcards.count) terms")
                                                        .font(.subheadline)
                                                        .foregroundColor(.white)

                                                    Spacer().frame(height: 6)
                                                }
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding()

                                                Divider().background(Color.white.opacity(0.3))

                                                HStack(spacing: 0) {
                                                    NavigationLink(destination: ChatInterfaceView(set: set)) {
                                                        Text("Chatbot")
                                                            .font(.subheadline)
                                                            .bold()
                                                            .frame(maxWidth: .infinity)
                                                            .padding()
                                                            .foregroundColor(.white)
                                                            .background(Color(hex: "#6213D0"))
                                                    }

                                                    NavigationLink(destination: SetView().onAppear {
                                                        studySetViewModel.currentlyChosenStudySet = set
                                                    }) {
                                                        Text("Flashcards")
                                                            .font(.subheadline)
                                                            .bold()
                                                            .frame(maxWidth: .infinity)
                                                            .padding()
                                                            .foregroundColor(.white)
                                                            .background(Color(hex: "#6213D0"))
                                                    }
                                                }
                                            }
                                            .background(Color(hex: "#71569E"))
                                            .cornerRadius(12)
                                            .padding(.horizontal)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    } else {
                                        Text("No Sets")
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(.top)
                            }
                        }
                    }
                }
                .navigationBarHidden(true)
                .onAppear {
                    studySetViewModel.listenToUserDocuments()
                    UITabBar.appearance().backgroundColor = UIColor.white
                    UITabBar.appearance().barTintColor = UIColor.white
                }
            }
        }
    }

    private func performSearch() {
        if !searchText.isEmpty {
            filteredSets = studySetViewModel.studySets.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
            recentSearches.insert(searchText, at: 0)
            if recentSearches.count > 10 {
                recentSearches.removeLast()
            }
            isSearching = false // Exit recent searches view
        }
    }

    private func clearSearch() {
        searchText = ""
        isSearching = false
        filteredSets = []
    }
}
