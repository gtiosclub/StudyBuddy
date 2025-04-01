//
//  HomeView.swift
//  StudyBuddy
//
//  Created by Eric Son on 2/6/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 32, height: 32)
                    Text("StudyBuddy")
                        .font(.title2)
                        .bold()
                    Spacer()
                    Button(action: {
                        // Add new set action
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
                .padding([.horizontal, .top])

                // Tabs
                HStack(spacing: 20) {
                    Text("All Sets").bold().underline()
                    Text("Recents").foregroundColor(.black)
                    Text("By you").foregroundColor(.black)
                    Text("By others").foregroundColor(.black)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)

                Divider()

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(0..<3) { _ in
                            VStack(alignment: .leading, spacing: 6) {
                                Text("MATH 1554 Linear Algebra")
                                    .font(.headline)

                                HStack(spacing: 8) {
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 20, height: 20)
                                    Text("john_doe18")
                                        .foregroundColor(.black)
                                        .font(.subheadline)
                                }

                                Text("48 terms")
                                    .font(.subheadline)
                                    .foregroundColor(.black)

                                Text("23 terms mastered")
                                    .font(.subheadline)
                                    .foregroundColor(.black)

                                Spacer().frame(height: 6)

                                

                                HStack(spacing: 40) {
                                    Spacer()
                                    Button(action: {
                                        // Chatbot functionality
                                    }) {
                                        Text("Chatbot")
                                            .font(.subheadline)
                                            .bold()
                                            .foregroundColor(.black)
                                    }
                                    Divider()
                                        .frame(height: 30)
                                    Button(action: {
                                        // Flashcards functionality
                                    }) {
                                        Text("Flashcards")
                                            .font(.subheadline)
                                            .bold()
                                            .foregroundColor(.black)
                                    }
                                    Spacer()
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.4))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }

                Divider()
                // Bottom Tab Bar
                HStack(spacing: 0) {
                    ForEach(0..<4) { index in
                        VStack {
                            Image(systemName: index == 0 ? "star.fill" : "star")
                                .foregroundColor(index == 0 ? .blue : .gray)
                            Text("Tab Name")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.top, 4)
                .padding(.bottom, 10)
                .background(Color.white.shadow(radius: 2))
            }
            .navigationBarHidden(true)
        }
    }
}

//OLD HOMEVIEW




//import SwiftUI
//
//
//struct HomeView: View {
//    @EnvironmentObject var authViewModel: AuthViewModel
//    @State private var isCompactView: Bool = true
//    private var sampleTextList: [String] = [
//        "A broad exposure to computer system structure and networking including software abstractions in operating systems for orchestrating the usage of the computing resources.",
//        "Computer data structures and algorithms in the context of object-oriented programming. Focus on software development towards applications.",
//        "Linear algebra, eigenvalues, eigenvectors, applications to linear systems, least squares, diagnolization, quadratic forms.",
//        "Introduction to the principles of programming languages including syntax, semantics, and the run-time environments.",
//        "Concepts of database systems and management; exploring relational databases, SQL, transaction mechanisms, database design, and normalization.",
//        "Theory and practical approaches to artificial intelligence, including machine learning algorithms, neural networks, and deep learning frameworks."
//    ]
//
//    private var sampleNameList: [String] = [
//        "CS2200 Exam 1",
//        "CS1332 Exam 2",
//        "MATH1554 Review",
//        "CS3240 Midterm",
//        "CS4400 Final Exam",
//        "CS7641 Machine Learning Quiz"
//    ]
//
//     var body: some View {
//        NavigationView {
//            VStack(spacing: 12) {
//                VStack(spacing: 8) {
//                    HStack {
//                        Text("StudyBuddy")
//                            .font(.largeTitle)
//                            .bold()
//                            .padding(.leading)
//                        Spacer()
//                        Button(action: {
//                            isCompactView.toggle()
//                        }) {
//                            Image(systemName: isCompactView ? "rectangle.grid.1x2" : "rectangle.grid.2x2")
//                                .resizable()
//                                .frame(width: 25, height: 25)
//                                .foregroundColor(.gray)
//                        }
//                        HStack(spacing: 8) {
//                            Circle()
//                                .fill(Color.gray.opacity(0.3))
//                                .frame(width: 20, height: 20)
////                            Circle()
////                                .fill(Color.gray.opacity(0.3))
////                                .frame(width: 20, height: 20)
//                        }
//                        Button(action: {
//                            authViewModel.logoutUser()
//                        }) {
//                            Image(systemName: "person.fill.badge.minus")
//                                .resizable()
//                                .frame(width: 25, height: 25)
//                                .foregroundColor(.gray)
//                        }
//                        .padding(.trailing)
//                    }
//                    .padding(.top, 16)
//                    
//                    HStack(spacing: 8) {
//                        ForEach(0..<3) { index in
//                            RoundedRectangle(cornerRadius: 8)
//                                .fill(Color.gray.opacity(0.3))
//                                .frame(height: 30)
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//                .background(Color.gray.opacity(0.2))
//                
//                ScrollView {
//                    VStack(spacing: 12) {
//                        ForEach(Array(sampleTextList.enumerated()), id: \.element) { index, text in
//                            Button(action: {
//                                // Card action
//                            }) {
//                                RoundedRectangle(cornerRadius: 12)
//                                    .fill(Color.gray.opacity(0.2))
//                                    .frame(height: isCompactView ? 100 : 180)
//                                    .overlay(
//                                        HStack(spacing: 8) {
//                                            Circle()
//                                                .fill(Color.gray)
//                                                .frame(width: 30, height: 30)
//                                            VStack(alignment: .leading, spacing: 4) {
//                                                Text(sampleNameList[index])
//                                                    .font(.headline)
//                                                    .foregroundColor(.gray)
//                                                Text(text)
//                                                    .font(.subheadline)
//                                                    .multilineTextAlignment(.leading)
//                                                    .foregroundColor(.gray.opacity(0.8))
//                                            }
//                                            Spacer()
//                                        }
//                                        .padding()
//                                    )
//                                    .padding(.horizontal)
//                            }
//                        }
//                    }
//                }
//                .gesture(DragGesture())
//                .padding(.bottom, 20)
//                
//            }
//        }
//    }
//}
////    @State var widgets: [String: String] = [
////        "2200": "A broad exposure to computer system structure and networking including software abstractions in operating systems for orchestrating the usage of the computing resources.",
////        "1332": "Computer data structures and algorithms in the context of object-oriented programming. Focus on software development towards applications.",
////        "1554": "Linear Algebra, Linear algebra eigenvalues, eigenvectors, applications to linear systems, least squares, diagnolization, quadratic forms."]
////    @State private var expandedDescriptions: Set<String> = []
////    var body: some View {
////        VStack(alignment: .leading) {
////            Text("StuddyBuddy")
////                .font(.headline)
////                .padding(.vertical)
////            ForEach(widgets.keys.sorted(), id: \.self) { key in
////                VStack(alignment: .leading, spacing: 5) {
////                    Button(action: {
////                        withAnimation {
////                            if expandedDescriptions.contains(key) {
////                                expandedDescriptions.remove(key)
////                            } else {
////                                expandedDescriptions.insert(key)
////                            }
////                        }
////                    }) {
////                        VStack {
////                            HStack {
////                                Text(key)
////                                    .font(.headline)
////                                    .foregroundColor(.white)
////                                Spacer()
////                                Image(systemName: "circle")
////                                    .foregroundColor(.white)
////                                Image(systemName: "circle")
////                                    .foregroundColor(.white)
////                            }
////                            Text(widgets[key] ?? "No Description")
////                                .font(.headline)
////                                .foregroundColor(.white)
////                                .frame(maxHeight: 20)
////
////                        }
////                        .padding()
////                        .frame(maxWidth: .infinity)
////                        .background(Color.black)
////                        .cornerRadius(10)
////                    }
////
////                    // class desc
////                    if expandedDescriptions.contains(key) {
////                        Text(widgets[key] ?? "No Description")
////                            .padding()
////                            .frame(maxWidth: .infinity, alignment: .leading)
////                            .background(Color.gray.opacity(0.2))
////                            .cornerRadius(10)
////                    }
////                }
////                .padding()
////            }
////            Spacer()
////        }
////        .padding()
////    }
////}
