//
//  HomeView.swift
//  StudyBuddy
//
//  Created by Tejeshwar Natarajan on 2/6/25.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showChangePassword = false

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .padding()

            Button(action: { showChangePassword = true }) {
                Text("Change Password")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            .sheet(isPresented: $showChangePassword) {
                ChangePasswordView(showPasswordChange: $showChangePassword)
                    .environmentObject(authViewModel)
            }

            Button(action: authViewModel.logoutUser) {
                Text("Log Out")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}
