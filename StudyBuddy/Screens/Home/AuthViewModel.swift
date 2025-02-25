//
//  AuthViewModel.swift
//  StudyBuddy
//
//  Created by Madhumita Subbiah on 2/20/25.
//

import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false

    init() {
        Auth.auth().addStateDidChangeListener { _, user in
            self.isLoggedIn = (user != nil)
        }
    }

    func logoutUser() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
