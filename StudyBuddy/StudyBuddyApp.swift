//
//  StudyBuddyApp.swift
//  StudyBuddy
//
//  Created by Tejeshwar Natarajan on 2/6/25.
//

import SwiftUI

@main
struct StudyBuddyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    OpenAIManager.shared.sendRequest(prompt: "What is the tallest building in the world", completion: { response in
                        switch response {
                        case .success(let text):
                            print(text)
                        case .failure(let error):
                            print(error)
                        }
                    })
                }
        }
    }
}
