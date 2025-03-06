//
//  ContentView.swift
//  StudyBuddy
//
//  Created by Jihoon Kim on 3/4/25.
//

import SwiftUI

struct ContentView: View {
    @State var selectedView: TabSelection = .home
    var body: some View {
        TabView(selection: $selectedView) {
            HomeView().tabItem {
                Label("Home", systemImage: "house.fill")
            }.tag(TabSelection.home)
            HomeView().tabItem {
                Label("Upload", systemImage: "arrow.up.circle.fill")
            }.tag(TabSelection.upload)
            FileViewer().tabItem {
                Label("Files", systemImage: "folder.fill")
            }.tag(TabSelection.files)
            SetView().tabItem {
                Label("Study", systemImage: "book.pages")
            }.tag(TabSelection.profile)
            HomeView().tabItem {
                Label("Chat", systemImage: "bubble.left.and.text.bubble.right.fill")
            }.tag(TabSelection.chat)
        }
    }
}

enum TabSelection {
    case home, upload, chat, profile, files
}

#Preview {
    ContentView()
}
