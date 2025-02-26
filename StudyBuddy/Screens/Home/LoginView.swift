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
    @State private var isLoginMode: Bool = true

    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            Picker(selection: $isLoginMode, label: Text("Picker here")) {
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

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: isLoginMode ? loginUser : registerUser) {
                Text(isLoginMode ? "Login" : "Create Account")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isLoginMode ? Color.blue : Color.green)
                    .cornerRadius(10)
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
