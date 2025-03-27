//
//  HomeView.swift
//  StudyBuddy
//
//  Created by Eric Son on 2/6/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isCompactView: Bool = true
    @State private var isProfilePresented: Bool = false  // Track if profile sheet is presented
    
    private var sampleTextList: [String] = [
        "A broad exposure to computer system structure and networking including software abstractions in operating systems for orchestrating the usage of the computing resources.",
        "Computer data structures and algorithms in the context of object-oriented programming. Focus on software development towards applications.",
        "Linear algebra, eigenvalues, eigenvectors, applications to linear systems, least squares, diagonalization, quadratic forms.",
        "Introduction to the principles of programming languages including syntax, semantics, and the run-time environments.",
        "Concepts of database systems and management; exploring relational databases, SQL, transaction mechanisms, database design, and normalization.",
        "Theory and practical approaches to artificial intelligence, including machine learning algorithms, neural networks, and deep learning frameworks."
    ]

    private var sampleNameList: [String] = [
        "CS2200 Exam 1",
        "CS1332 Exam 2",
        "MATH1554 Review",
        "CS3240 Midterm",
        "CS4400 Final Exam",
        "CS7641 Machine Learning Quiz"
    ]

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
                        Button(action: {
                            isProfilePresented = true  // Navigate to the profile section
                        }) {
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 16)
                    
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { _ in
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
                        ForEach(Array(sampleTextList.enumerated()), id: \.element) { index, text in
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
                                                Text(sampleNameList[index])
                                                    .font(.headline)
                                                    .foregroundColor(.gray)
                                                Text(text)
                                                    .font(.subheadline)
                                                    .multilineTextAlignment(.leading)
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
            }
            .sheet(isPresented: $isProfilePresented) {
                ViewEditProfile()
                    .environmentObject(authViewModel)
            }
        }
    }
}
