//
//  ChangePasswordView.swift
//  StudyBuddy
//
//  Created by Madhumita Subbiah on 2/27/25.
//

import SwiftUI
import FirebaseAuth

struct ChangePasswordView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var showPasswordChange: Bool
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                SecureField("Current Password", text: $currentPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("New Password", text: $newPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Button(action: changePassword) {
                    Text("Update Password")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Change Password")
        }
    }

    func changePassword() {
        authViewModel.changePassword(currentPassword: currentPassword, newPassword: newPassword) { result in
            errorMessage = result
            if result == "Password successfully updated." {
                showPasswordChange = false
            }
        }
    }
}
