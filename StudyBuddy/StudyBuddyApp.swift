//
//  StudyBuddyApp.swift
//  StudyBuddy
//
//  Created by Tejeshwar Natarajan on 2/6/25.
//

import SwiftUI

@main
struct StudyBuddyApp: App {
    
    var body: some Scene {
        WindowGroup {
            TabView {
                
                ContentView()
                    .tabItem {
                        Image(systemName: "1.circle")
                        Text("First")
                    }
                
                ChatInterfaceView()
                    .tabItem {
                        Image(systemName: "2.circle")
                        Text("Chat")
                    }
            }
            .modelContainer(for: [Thread.self, Message.self])
        }
    }
}
