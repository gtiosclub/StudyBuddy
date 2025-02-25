//
//  HomeView.swift
//  StudyBuddy
//
//  Created by Tejeshwar Natarajan on 2/6/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .padding()
            
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
