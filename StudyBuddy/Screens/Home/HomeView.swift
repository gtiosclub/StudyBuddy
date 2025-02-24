//
//  HomeView.swift
//  StudyBuddy
//
//  Created by Eric Son on 2/6/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                VStack(spacing: 8) {
                    HStack {
                        Text("StudyBuddy")
                            .font(.largeTitle)
                            .bold()
                            .padding(.leading)
                        Spacer()
                        Button(action: {
                            // Profile action
                        }) {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray)
                                .padding(.trailing)
                        }
                    }
                    .padding(.top, 16)
                    
                    HStack(spacing: 8) {
                        ForEach(0..<3) { _ in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 40)
                        }
                    }
                    .padding(.horizontal)
                }
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(0..<5) { _ in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 100)
                                .overlay(
                                    HStack(spacing: 12) {
                                        Circle()
                                            .fill(Color.gray)
                                            .frame(width: 40, height: 40)
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Placeholder Title")
                                                .font(.headline)
                                                .foregroundColor(.gray)
                                            Text("Placeholder description text goes here.")
                                                .font(.subheadline)
                                                .foregroundColor(.gray.opacity(0.8))
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                )
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
