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

    var body: some View {
        TabView(selection: $selectedView) {
            HomeView().tabItem {
                Label("Home", systemImage: "house.fill")
            }.tag(TabSelection.home)
                .environmentObject(authViewModel)
            FileViewer().tabItem {
                Label("Files", systemImage: "folder.fill")
            }.tag(TabSelection.files)
            SearchView().tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }.tag(TabSelection.search)
                .environmentObject(authViewModel)
            HomeView().tabItem {
                Label("Chat", systemImage: "bubble.left.and.text.bubble.right.fill")
            }.tag(TabSelection.chat)
                .environmentObject(authViewModel)
        }
    }
}

enum TabSelection {
    case home, search, chat, profile, files
}

#Preview {
    ContentView()
}
