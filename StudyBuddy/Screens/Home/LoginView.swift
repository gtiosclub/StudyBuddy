//
//  LoginView.swift
//  StudyBuddy
//
//  Created by Madhumita Subbiah on 2/11/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var firstName: String = ""  // Added for first name
    @State private var lastName: String = ""   // Added for last name
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

            TextField("Enter email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()

            SecureField("Enter password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Add fields for first name and last name when creating an account
            if !isLoginMode {
                TextField("Enter first name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Enter last name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }

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
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()

            if isLoginMode {
                Button("Forgot Password?") {
                    authViewModel.resetPassword(email: email) { message in
                        resetSuccessMessage = message
                    }
                }
                .foregroundColor(.blue)
                .padding(.top, 5)
            }
        }
        .padding()
    }

    func handleAuthAction() {
        if isLoginMode {
            authViewModel.loginUser(email: email, password: password) { error in
                errorMessage = error
            }
        } else {
            // Pass firstName and lastName to registerUser
            authViewModel.registerUser(email: email, password: password, firstName: firstName, lastName: lastName) { error in
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
