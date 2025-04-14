//
//  HomeView.swift
//  StudyBuddy
//
//  Created by Eric Son on 2/6/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var studySetViewModel: StudySetViewModel
    @State private var selectedTab: Tab = .all
    @State private var showPopup = false

    enum Tab: String, CaseIterable {
        case all = "All Sets"
        case recents = "Recents"
        case byYou = "By you"
        case byOthers = "By others"
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#321C58").ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        NavigationLink(destination: ViewEditProfile()
                            .environmentObject(authViewModel)
                            .environmentObject(UserViewModel())) {
                                Circle()
                                    .fill(Color.white.opacity(0.3))
                                    .frame(width: 32, height: 32)
                            }
                        Spacer()
                        Text("StudyBuddy")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            withAnimation {
                                showPopup = true
                            }
                        } label: {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                    .padding([.horizontal, .top])

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
                            if studySetViewModel.studySets.count > 0 {
                                ForEach(studySetViewModel.studySets) { set in
                                    FlashcardSetRow(set: set)
                                }
                            } else {
                                Text("No Sets")
                            }
                        }
                        .padding(.top)
                        .environmentObject(studySetViewModel)
                    }
                    .environmentObject(studySetViewModel)

                }
                .background(Color(hex: "#321C58").edgesIgnoringSafeArea(.all))

                if showPopup {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showPopup = false
                            }
                        }

                    CreateSetView(showPopup: $showPopup)
                        .transition(.scale)
                        .zIndex(1)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                studySetViewModel.listenToUserDocuments()
            }
            .onDisappear {
                studySetViewModel.closeSnapshotListener()
            }
            .background(Color(hex: "#321C58").edgesIgnoringSafeArea(.all))

        }
    }
    
    private var setsView: some View {
        ScrollView {
            VStack(spacing: 12) {
                if studySetViewModel.studySets.count > 0 {
                    ForEach(studySetViewModel.studySets) { set in
                        FlashcardSetRow(set: set)
                    }
                } else {
                    Text("No Sets")
                }
            }
            .padding(.top)
            .environmentObject(studySetViewModel)
        }
        .environmentObject(studySetViewModel)
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
