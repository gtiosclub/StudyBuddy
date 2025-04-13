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
            HomeView().tabItem {
                Label("Upload", systemImage: "arrow.up.circle.fill")
            }.tag(TabSelection.upload)
                .environmentObject(authViewModel)
            FileViewer().tabItem {
                Label("Files", systemImage: "folder.fill")
            }.tag(TabSelection.files)
            HomeView().tabItem {
                Label("Chat", systemImage: "bubble.left.and.text.bubble.right.fill")
            }.tag(TabSelection.chat)
                .environmentObject(authViewModel)
        }
        .onChange(of: selectedView) { newValue in
            if newValue == .upload {
                isPickerPresented = true
            }
        }
        .sheet(isPresented: $isPickerPresented, onDismiss: {
            selectedView = .files
        }) {
            DocumentPickerView(uploadViewModel: uploadViewModel)
        }
        .sheet(isPresented: $uploadViewModel.isUploadPresented, onDismiss: {
            selectedView = .files
        }) {
            UploadView(uploadViewModel: uploadViewModel)
                .presentationDetents([.medium, .fraction(0.5)])
                .cornerRadius(30)
                .background(EmptyView())
        }
    }
}

enum TabSelection {
    case home, upload, chat, profile, files
}

#Preview {
    ContentView()
}
