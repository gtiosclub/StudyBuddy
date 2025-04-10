//
//  LoginView.swift
//  StudyBuddy
//
//  Created by Madhumita Subbiah on 2/11/25.
//

import SwiftUI
import FirebaseAuth

extension Color {
    static let darkPurple = Color(red: 50 / 255, green: 28 / 255, blue: 88 / 255)
    static let lightPurple = Color(red: 113 / 255, green: 86 / 255, blue: 158 / 255)
}

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isLoginMode: Bool = true
    @State private var resetSuccessMessage: String?

    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            Picker(selection: $isLoginMode, label: Text("Authentication")) {
                Text("Login").tag(true)
                Text("Create Account").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .background(Color.lightPurple.opacity(0.2))
            .cornerRadius(8)

            TextField("Enter email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()

            SecureField("Enter password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            if let resetSuccessMessage = resetSuccessMessage {
                Text(resetSuccessMessage)
                    .foregroundColor(.green)
                    .padding()
            }

            Button(action: handleAuthAction) {
                Text(isLoginMode ? "Login" : "Create Account")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.darkPurple)
                    .cornerRadius(10)
            }
            .padding()

            if isLoginMode {
                Button("Forgot Password?") {
                    authViewModel.resetPassword(email: email) { message in
                        resetSuccessMessage = message
                    }
                }
                .foregroundColor(.lightPurple)
                .padding(.top, 5)
            }
        }
        .padding()
        .background(Color.darkPurple.opacity(0.05))
        .cornerRadius(20)
        .padding()
    }

    func handleAuthAction() {
        if isLoginMode {
            authViewModel.loginUser(email: email, password: password) { error in
                errorMessage = error
            }
        } else {
            authViewModel.registerUser(email: email, password: password) { error in
                if let error = error {
                    errorMessage = error
                } else {
                    authViewModel.sendVerificationEmail()
                    errorMessage = "Verification email sent. Please check your inbox."
                }
            }
        }
    }
}
