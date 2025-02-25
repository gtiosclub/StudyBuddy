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
    @State private var errorMessage: String?

    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
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

            Button(action: loginUser) {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()

            Button(action: registerUser) {
                Text("Create Account")
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .padding()
    }

    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                errorMessage = error.localizedDescription
            }
        }
    }

    func registerUser() {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                errorMessage = error.localizedDescription
            }
        }
    }
}
