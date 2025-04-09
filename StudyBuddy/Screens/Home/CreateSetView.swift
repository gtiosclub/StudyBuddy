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
    var body: some View {
        VStack {
            TextField("New Set", text: $name)
                .foregroundColor(.white)
            Button(action: {
//                isPresented = true
                studySet = StudySetModel(flashcards: [], dateCreated: Date(), createdBy: Auth.auth().currentUser?.uid ?? "Unknown UserID", name: name, documentIDs: [])
                studySetView.createStudySetDocument(studySet: studySet ?? StudySetModel(flashcards: [], dateCreated: Date(), createdBy: "", name: name, documentIDs: []))
                showPopup = false
                
            }) {
                Text("Add Set")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(.gray)
        .cornerRadius(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .sheet(isPresented: $isPresented) {
            DocumentPickerView(uploadViewModel: uploadViewModel)
        }
    }

}

