//
//  login.swift
//  StudyBuddy
//
//  Created by Eric Son on 2/27/25.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .bold()
                .padding(.top, 40)
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button(action: {
                if username.isEmpty || password.isEmpty {
                    errorMessage = "Please enter both username and password."
                } else {
                    errorMessage = ""
                    // Proceed with login logic
                }
            }) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .padding(.top, 10)
            
            Button(action: {
                // Forgot password logic
            }) {
                Text("Forgot Password?")
                    .foregroundColor(.blue)
            }
            .padding(.top, 5)
            
            Spacer()
        }
    }
}

#Preview {
    LoginView()
}
