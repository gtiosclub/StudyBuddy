//
//  StudyBuddyApp.swift
//  StudyBuddy
//
//  Created by Tejeshwar Natarajan on 2/6/25.
//

import SwiftUI
import FirebaseCore
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
@main

struct StudyBuddyApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject var userViewModel = UserViewModel()

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
            WindowGroup {
                if authViewModel.isLoggedIn {
                    ContentView()
                        .environmentObject(authViewModel)
                        .environmentObject(userViewModel) // Inject userViewModel here
                } else {
                    LoginView()
                        .environmentObject(authViewModel)
                        .environmentObject(userViewModel) // Inject userViewModel here
                }
        }
    }
}

