//
//  StudyBuddyApp.swift
//  StudyBuddy
//
//  Created by Tejeshwar Natarajan on 2/6/25.
//

import SwiftUI
import FirebaseCore
import FirebaseStorage

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    
    // Initialize Storage Bucket
    let _ = Storage.storage(url: "gs://studybuddy-7df38.appspot.com")

    return true
  }
}

@main
struct StudyBuddyApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var uploadViewModel = UploadViewModel()
    @StateObject private var studySetViewModel = StudySetViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            if authViewModel.isLoggedIn {
                ContentView().environmentObject(authViewModel)
                    .environmentObject(uploadViewModel)
                    .environmentObject(studySetViewModel)
            } else {
                LoginView().environmentObject(authViewModel)
                    .environmentObject(uploadViewModel)
                    .environmentObject(studySetViewModel)
            }
        }
    }
}

