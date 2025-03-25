//
//  EditView.swift
//  StudyBuddy
//
//  Created by Sean Yan on 3/4/25.
//

import SwiftUI

struct EditView: View {
    
    @ObservedObject var studySet: StudySet
    @State private var flashCardIndex = 0
    @State private var showBack = false
    @State private var currentText: String = ""
    
    init(studySet: StudySet) {
        self.studySet = studySet
    }
    
    var body: some View {
        Spacer()
            Text("EditView Mockup")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
        
        cardEditView()
        Spacer()
        addCardView()

    }
    
    private func addCardView() -> some View {
        HStack {
            Button(action: {
                studySet.add_flashcard(front: "front", back: "back")
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.blue)
            }
        }
    }
    private func cardEditView() -> some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(Array(studySet.set.keys), id: \.self) { key in
                    if let (word, definition) = studySet.set[key] {
                        IndividualCardEditView(studySet: studySet, word: word, definition: definition, key: key)
                    }
                }
            }
        }
    }
    
    struct IndividualCardEditView: View {
        @ObservedObject var studySet: StudySet
        @State private var word: String
        @State private var definition: String
        @State private var expanded = false
        @State private var editMode = false
        private var key: String
        init(studySet: StudySet, word: String, definition: String, key: String) {
            self.studySet = studySet
            self._word = State(initialValue: word)
            self._definition = State(initialValue: definition)
            self.key = key
        }
        
        var body: some View {
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(radius: 3)
                    .padding(2)

                VStack {
                    HStack {
                        if (editMode) {
                            TextField("Front", text: $word)
                                .padding(.trailing, 100)
                                .padding(.leading, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Text(word)
                                .font(.body)
                                .padding(.trailing, 100)
                                .padding(.leading, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
//                            .fixedSize(horizontal: false, vertical: true)
                            
                    }
                    HStack {
                        HotizontalBarView()
                    }
                    HStack {
                        if (editMode) {
                            TextField("Definition", text: $definition)
                                .padding(.trailing, 100)
                                .padding(.leading, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Text(definition)
                                .font(.body)
                                .padding(.trailing, 100)
                                .padding(.leading, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding(10)
                VStack {
                    HStack {
                        Spacer()
                        editButtons()
                            .padding(.top, 8)
                    }
                    Spacer()
                }
                .padding(.trailing, 15)
            }
            .frame(width: 375)
        }
            
        private func editButtons() -> some View {
            HStack {
                
                Button(action: {
                    editMode.toggle()
                    if (!editMode) {
                        studySet.edit_flashcard(key: key, front:word, back: definition)
                    }
                    
                }) {
                    Image(systemName: editMode ? "checkmark.circle" : "pencil")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                
                Button(action: {
                    print("delete")
//                    studySet.remove_flashcard(key: key)
                }) {
                    Image(systemName: "trash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
               
            }
            .padding(.trailing, 0)
        }
    
    }
    
    struct HotizontalBarView: View {
        var body: some View {
            Rectangle()
                .fill(Color.gray)
                .frame(width: 330, height: 1)
        }
    }
    
}

#Preview {
    EditView(studySet: StudySet(set: ["1":("Hello","World"), "2":("Swift","UI"), "3":("SwiftUI","booo"), "4":("Card","definition"), "5":("Onemore","card")]))
}
