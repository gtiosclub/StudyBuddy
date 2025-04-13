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
            VStack(spacing: 20) {
                SecureField("Current Password", text: $currentPassword)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .padding(.horizontal)

                SecureField("New Password", text: $newPassword)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .padding(.horizontal)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

                Button(action: changePassword) {
                    Text("Update Password")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#6213D0"))
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Button("Cancel") {
                    showPasswordChange = false
                }
                .foregroundColor(.red)
                .padding()

                Spacer()
            }
            .padding(.top)
            .background(Color(hex: "#321C58").edgesIgnoringSafeArea(.all))
            .navigationTitle("Change Password")
            .foregroundColor(.white)
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
