//
//  UserViewModel.swift
//  StudyBuddy
//
//  Created by Tejeshwar Natarajan on 2/6/25.
//

import Foundation

import FirebaseCore
import FirebaseFirestore

class UserViewModel {
    @Published var user = UserModel()
        
    //When user logs in, this function should be called which fetches the data related to the currently logged-in user and stores it in this current user instance
    func fetchData() -> () {
        
    }
    
    //cleares the data stored in this instance
    func clearData() -> () {
        
    }
    
    
    //updates all the values stored in the database of the currently logged in user when called (updates values stored in the database from the currentuser instances)
    func updateData() -> () {
        
    }
}
