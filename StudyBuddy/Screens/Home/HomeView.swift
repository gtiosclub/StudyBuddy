//
//  HomeView.swift
//  StudyBuddy
//
//  Created by Eric Son on 2/6/25.
//

import SwiftUI

struct HomeView: View {
    @State private var isCompactView: Bool = false
    
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
                            isCompactView.toggle()
                        }) {
                            Image(systemName: isCompactView ? "rectangle.grid.1x2" : "rectangle.grid.2x2")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.gray)
                        }
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 20, height: 20)
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 20, height: 20)
                        }
                        .padding(.trailing)
                    }
                    .padding(.top, 16)
                    
                    HStack(spacing: 8) {
                        ForEach(0..<5) { _ in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 30)
                        }
                    }
                    .padding(.horizontal)
                }
                .background(Color.gray.opacity(0.2))
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(0..<10) { _ in
                            Button(action: {
                                // Card action
                            }) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: isCompactView ? 100 : 180)
                                    .overlay(
                                        HStack(spacing: 8) {
                                            Circle()
                                                .fill(Color.gray)
                                                .frame(width: 30, height: 30)
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
                .gesture(DragGesture())
                .padding(.bottom, 20)
                
                Spacer()
                
                HStack {
                    ForEach(0..<4) { index in
                        Button(action: {
                            // Tab action
                        }) {
                            VStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(index == 0 ? .blue : .gray)
                                Text("Tab Name")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(Color.white)
                .shadow(radius: 5)
            }
        }
    }
}

#Preview {
    HomeView()
}
