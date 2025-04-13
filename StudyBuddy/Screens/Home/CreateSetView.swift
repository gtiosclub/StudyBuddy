//
//  CreateSetView.swift
//  StudyBuddy
//
//  Created by Tony Nguyen on 4/8/25.
//

import Foundation
import SwiftUI
import FirebaseAuth
struct CreateSetView: View {
    @State private var name: String = ""
    @EnvironmentObject var uploadViewModel: UploadViewModel
    @EnvironmentObject var studySetView: StudySetViewModel
    @State var isPresented: Bool = false
    @State private var studySet: StudySetModel?
    @Binding var showPopup: Bool
    @State private var showFileViewer = false
    @State private var addSet: StudySetModel?

    var body: some View {
        VStack(spacing: 20) {
            Text("Create Study Set")
                .font(.title2)
                .bold()
                .foregroundColor(.white)

            TextField("Set Name", text: $name)
                .padding()
                .background(.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.2)))

            Button(action: {
                studySet = StudySetModel(
                    flashcards: [],
                    dateCreated: Date(),
                    createdBy: Auth.auth().currentUser?.uid ?? "Unknown UserID",
                    name: name,
                    documentIDs: []
                )

                Task {
                    do {
                        addSet = try await studySetView.createStudySetDocumentAndReturn(
                            studySet: studySet ?? StudySetModel(
                                flashcards: [],
                                dateCreated: Date(),
                                createdBy: "",
                                name: name,
                                documentIDs: []
                            )
                        )
                        showFileViewer = true
                    } catch {
                        print("Failed to add and return document: \(error.localizedDescription)")
                    }
                }

            }) {
                Text("Continue")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "#6213D0"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }

            NavigationLink(
                destination: FileToSetView(
                    addSet: addSet ?? StudySetModel(
                        flashcards: [],
                        dateCreated: Date(),
                        createdBy: Auth.auth().currentUser?.uid ?? "Unknown UserID",
                        name: name,
                        documentIDs: []
                    ),
                    showPopup: $showPopup
                ),
                isActive: $showFileViewer
            ) {
                EmptyView()
            }
        }
        .padding(24)
        .background(Color(hex: "#321C58"))
        .cornerRadius(24)
        .frame(maxWidth: 400, maxHeight: 300) 
        .padding()
        .shadow(radius: 10)
        .sheet(isPresented: $isPresented) {
            DocumentPickerView(uploadViewModel: uploadViewModel)
        }
        .toolbar(showPopup ? .hidden : .visible, for: .tabBar)
    }
}
