//
//  HomeView.swift
//  StudyBuddy
//
//  Created by Eric Son on 2/6/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab: Tab = .all

    enum Tab: String, CaseIterable {
        case all = "All Sets"
        case recents = "Recents"
        case byYou = "By you"
        case byOthers = "By others"
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 32, height: 32)
                    Text("StudyBuddy")
                        .font(.title2)
                        .bold()
                    Spacer()
                    Button(action: {
                        // Add new set
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
                .padding([.horizontal, .top])

                // Tabs
                HStack(spacing: 20) {
                    ForEach(Tab.allCases, id: \.self) { tab in
                        Button(action: {
                            selectedTab = tab
                        }) {
                            Text(tab.rawValue)
                                .fontWeight(tab == selectedTab ? .bold : .regular)
                                .underline(tab == selectedTab)
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)

                Divider()

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(0..<3) { _ in
                            VStack(spacing: 0) {
                                // Card content
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("MATH 1554 Linear Algebra")
                                        .font(.headline)

                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(Color.white.opacity(0.3))
                                            .frame(width: 20, height: 20)
                                        Text("john_doe18")
                                            .foregroundColor(.black)
                                            .font(.subheadline)
                                    }

                                    Text("48 terms")
                                        .font(.subheadline)
                                        .foregroundColor(.black)

                                    Text("23 terms mastered")
                                        .font(.subheadline)
                                        .foregroundColor(.black)

                                    Spacer().frame(height: 6)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()

                                Divider()

                                HStack(spacing: 0) {
                                    Button(action: {
                                        // Chatbot functionality
                                    }) {
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

                                    Button(action: {
                                        // Flashcards functionality
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
                    }
                    .padding(.top)
                }

                Divider()

                // Bottom Tab Bar
                HStack(spacing: 0) {
                    ForEach(0..<4) { index in
                        VStack {
                            Image(systemName: index == 0 ? "star.fill" : "star")
                                .foregroundColor(index == 0 ? .blue : .gray)
                            Text("Tab Name")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.top, 4)
                .padding(.bottom, 10)
                .background(Color.white.shadow(radius: 2))
            }
            .navigationBarHidden(true)
        }
    }
}
