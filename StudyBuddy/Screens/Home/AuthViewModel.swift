
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
        self.isLoggedIn = Auth.auth().currentUser?.isEmailVerified ?? false
    }

    func logoutUser() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    func resetPassword(email: String, completion: @escaping (String) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion("Error sending reset email: \(error.localizedDescription)")
            } else {
                completion("Password reset email sent.")
            }
        }
    }

    func sendVerificationEmail() {
        guard let user = Auth.auth().currentUser else { return }
        user.sendEmailVerification { error in
            if let error = error {
                print("Error sending verification email: \(error.localizedDescription)")
            } else {
                print("Verification email sent.")
            }
        }
    }

    func changePassword(currentPassword: String, newPassword: String, completion: @escaping (String?) -> Void) {
        guard let user = Auth.auth().currentUser, let email = user.email else {
            completion("User not found.")
            return
        }

        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)

        user.reauthenticate(with: credential) { _, error in
            if let error = error {
                completion("Re-authentication failed: \(error.localizedDescription)")
                return
            }

            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    completion("Password update failed: \(error.localizedDescription)")
                } else {
                    self.logoutUser()
                    completion("Password successfully updated. Please log in again.")
                }
            }
        }
    }

    func loginUser(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion("Login failed: \(error.localizedDescription)")
            } else {
                guard let user = result?.user else {
                    completion("Unexpected error: User not found.")
                    return
                }

                if !user.isEmailVerified {
                    completion("Please verify your email before logging in.")
                    self.logoutUser()
                } else {
                    DispatchQueue.main.async {
                        self.isLoggedIn = true
                    }
                    let userViewModel = UserViewModel()
                    userViewModel.fetchUser()
                    completion(nil)
                }
            }
        }

    }

    func registerUser(email: String, password: String, firstName: String, lastName: String, completion: @escaping (String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion("Registration failed: \(error.localizedDescription)")
            } else {
                self.sendVerificationEmail()
                if let uid = result?.user.uid {
                    let userViewModel = UserViewModel()
                    userViewModel.storeUserData(uid: uid, firstName: firstName, lastName: lastName, email: email)
                }
                completion(nil)
            }
        }
    }

}
