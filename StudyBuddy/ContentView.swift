//
//  ContentView.swift
//  StudyBuddy
//
//  Created by Jihoon Kim on 3/4/25.
//
import SwiftUI

struct ContentView: View {
    @State var selectedView: TabSelection = .home
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var studySetViewModel: StudySetViewModel
    var body: some View {
        TabView(selection: $selectedView) {
            HomeView().tabItem {
                Label("Home", systemImage: "house.fill")
            }.tag(TabSelection.home)
                .environmentObject(authViewModel)
                .environmentObject(studySetViewModel)
            FileViewer().tabItem {
                Label("Files", systemImage: "folder.fill")
            }.tag(TabSelection.files)
                .environmentObject(studySetViewModel)
            SearchView().tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }.tag(TabSelection.search)
                .environmentObject(authViewModel)
                .environmentObject(studySetViewModel)
            ChatInterfaceView().tabItem {
                Label("Chat", systemImage: "bubble.left.and.text.bubble.right.fill")
            }.tag(TabSelection.chat)
                .environmentObject(authViewModel)
                .environmentObject(studySetViewModel)
        }
    }
}

enum TabSelection {
    case home, search, chat, profile, files
}

#Preview {
    ContentView()
}
