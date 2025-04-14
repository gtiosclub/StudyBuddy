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
    @State private var selectedBottomTab: Int = 0

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
                    NavigationLink(destination: ViewEditProfile()
                        .environmentObject(authViewModel)
                        .environmentObject(UserViewModel())) {
                            Circle()
                                .fill(Color.white.opacity(0.3))
                                .frame(width: 32, height: 32)
                        }

                    Text("StudyBuddy")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)

                    Spacer()

                    Button(action: {
                        // Future: Add new set functionality
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.white)
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
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)

                Divider().background(Color.white.opacity(0.3))

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(0..<3) { _ in
                            VStack(spacing: 0) {
                                // Card content
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Intro to Swift")
                                        .font(.headline)
                                        .foregroundColor(.white)

                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(Color.white.opacity(0.3))
                                            .frame(width: 20, height: 20)
                                        Text("john_doe18")
                                            .foregroundColor(.white)
                                            .font(.subheadline)
                                    }

                                    Text("48 terms")
                                        .font(.subheadline)
                                        .foregroundColor(.white)

                                    Text("23 terms mastered")
                                        .font(.subheadline)
                                        .foregroundColor(.white)

                                    Spacer().frame(height: 6)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()

                                Divider().background(Color.white.opacity(0.3))

                                HStack(spacing: 0) {
                                    NavigationLink(destination: ChatInterfaceView()) {
                                        Text("Chatbot")
                                            .font(.subheadline)
                                            .bold()
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .foregroundColor(.white)
                                            .background(Color(hex: "#6213D0"))
                                    }

                                    Rectangle()
                                        .frame(width: 1, height: 33)
                                        .foregroundColor(.white.opacity(0.5))

                                    NavigationLink(destination: SetView()) {
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
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.top)
                }

                Divider()

//                Divider().background(Color.white.opacity(0.3))
//
//                // Bottom Tab Bar
//                HStack(spacing: 0) {
//                    ForEach(0..<5) { index in
//                        let isSelected = selectedBottomTab == index
//                        let tabName = ["Home", "Upload", "Files", "Study", "Chat"][index]
//                        let tabIcon = ["house", "square.and.arrow.up", "folder", "book", "bubble.left"][index]
//
//                        Button(action: {
//                            selectedBottomTab = index
//                        }) {
//                            VStack {
//                                Image(systemName: tabIcon)
//                                    .foregroundColor(isSelected ? .white : Color(hex: "#71569E"))
//                                Text(tabName)
//                                    .font(.caption)
//                                    .foregroundColor(isSelected ? .white : Color(hex: "#71569E"))
//                            }
//                            .frame(maxWidth: .infinity)
//                        }
//                    }
//                }
//                .padding(.top, 4)
//                .padding(.bottom, 10)
//                .background(Color(hex: "#321C58").shadow(radius: 2))
            }
            .background(Color(hex: "#321C58").edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
        }
    }
}
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: .whitespacesAndNewlines))
        scanner.currentIndex = hex.startIndex

        var rgb: UInt64 = 0
        scanner.scanString("#", into: nil)
        scanner.scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255
        let green = Double((rgb >> 8) & 0xFF) / 255
        let blue = Double(rgb & 0xFF) / 255

        self.init(red: red, green: green, blue: blue)
    }
}

