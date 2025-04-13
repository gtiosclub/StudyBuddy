//
//  ContentView.swift
//  StudyBuddy
//
//  Created by Jihoon Kim on 3/4/25.
//
import SwiftUI

struct ContentView: View {
    @State var selectedView: TabSelection = .home
    @State private var isPickerPresented: Bool = false
    @EnvironmentObject private var uploadViewModel: UploadViewModel
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
                .environmentObject(authViewModel)
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
