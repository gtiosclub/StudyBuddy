//
//  UserModel.swift
//  StudyBuddy
//
//  Created by Tejeshwar Natarajan on 2/6/25.
//

import Foundation
import SwiftUI

import FirebaseFirestore

struct UserModel: Codable, Identifiable {
    @DocumentID var id: String?
    var email: String = ""
    var userName: String = ""
    var studySets: [StudySetModel] = []
}

func createTestUser(_ email: String, _ userName: String, _ date1: Date, _ date2: Date, _ date3: Date, _ flashcardText1: String, _ flashcardText2: String, _ flashcardText3: String) -> UserModel {
    var user: UserModel = UserModel(email: email, userName: userName)
    
    let flashcard1 = FlashcardModel(text: flashcardText1, createdBy: user.userName, mastered: false)
    let flashcard2 = FlashcardModel(text: flashcardText2, createdBy: user.userName, mastered: false)
    let flashcard3 = FlashcardModel(text: flashcardText3, createdBy: user.userName, mastered: false)
    
    
    user.studySets = [
        StudySetModel(flashcards: [flashcard1], dateCreated: date1, createdBy: user.userName),
        StudySetModel(flashcards: [flashcard2], dateCreated: date2, createdBy: user.userName),
        StudySetModel(flashcards: [flashcard3], dateCreated: date3, createdBy: user.userName),
    ]
    
    return user
}

func createDate(date: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    if let date = formatter.date(from: date) {
        return date
    }
    //default date if the string is invalid
    return Date()
}


//user1
let date1 = createDate(date: "2022-05-10")
let date2 = createDate(date:"2022-01-12")
let date3 = createDate(date: "2024-02-28")
let flashcardText1 = "test123"
let flashcardText2 = "test455"
let flashcardText3 = "testagain"
var user1 = createTestUser("bob123@gmail.com", "bob123", date1, date2, date3, flashcardText1, flashcardText2, flashcardText3)

//user 2
let date4 = createDate(date: "2021-07-13")
let date5 = createDate(date: "2019-10-13")
let date6 = createDate(date: "2010-11-28")
let flashcardText4 = "abcd123"
let flashcardText5 = "efjh456"
let flashcardText6 = "ijkl789"
var user2 = createTestUser("jim456@gmail.com", "jim456", date4, date5, date6, flashcardText1, flashcardText2, flashcardText3)

//user 3
let date7 = createDate(date: "2005-12-25")
let date8 = createDate(date: "2014-09-23")
let date9 = createDate(date: "2023-06-05")
let flashcardText7 = "falfa324"
let flashcardText8 = "1+1=2"
let flashcardText9 = "2^2=4"
var user3 = createTestUser("billy789@gmail.com", "billy789", date7, date8, date9, flashcardText7, flashcardText8, flashcardText9)
