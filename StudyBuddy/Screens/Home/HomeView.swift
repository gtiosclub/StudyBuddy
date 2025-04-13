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
    @EnvironmentObject var studySetViewModel: StudySetViewModel
    @State private var showPopup = false
    @State private var selectedBottomTab: Int = 0

    enum Tab: String, CaseIterable {
        case all = "All Sets"
        case recents = "Recents"
        case byYou = "By you"
        case byOthers = "By others"
    }

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        NavigationLink(destination: ViewEditProfile()
                            .environmentObject(authViewModel)
                            .environmentObject(UserViewModel())) {
                                Circle()
                                    .fill(Color.white.opacity(0.3))
                            .bold()
                        Spacer()
                        Text("StudyBuddy")
                            .font(.title2)
                            .bold()
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
                    
                    Divider().background(Color.white.opacity(0.3))
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(studySetViewModel.studySets) { set in
                                VStack(spacing: 0) {
                                    // Card content
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(set.name)
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
                                            .foregroundColor(.black)
                                        
                                        Text("23 terms mastered")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                        
                                        Spacer().frame(height: 6)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    
                                    Divider().background(Color.white.opacity(0.3))

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
                                                .padding()
                                                .foregroundColor(.black)
                                        }
                                    }
                                    .background(Color.white.opacity(0.5))
                                .padding()

                                Divider().background(Color.white.opacity(0.3))

                                HStack(spacing: 0) {
                                    Button(action: {
                                        // Chatbot functionality
                                    }) {
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

                                    Button(action: {
                                        // Flashcards functionality
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
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 10)
                    .background(Color.white.shadow(radius: 2))
                }
                .allowsHitTesting(!showPopup)
                .navigationBarHidden(true)
                if showPopup {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                    CreateSetView(showPopup: $showPopup)
                        .transition(.scale)
                        .zIndex(1)
                }
//                    ForEach(0..<5) { index in
        }
        .onAppear {
            studySetViewModel.listenToUserDocuments()
        }
        .onDisappear() {
            print("Snap Listener has closed.")
            studySetViewModel.closeSnapshotListener()

        }
        .background(Color(hex: "#321C58").edgesIgnoringSafeArea(.all))
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

