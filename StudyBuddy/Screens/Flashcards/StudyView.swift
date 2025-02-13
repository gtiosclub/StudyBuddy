//
//  StudyView.swift
//  StudyBuddy
//
//  Created by Jihoon Kim on 2/11/25.
//

import SwiftUI

struct StudyView: View {
    var hardcodedSet: [String: String] = ["Hello": "World", "Swift": "UI", "SwiftUI": "Is"]

    var body: some View {
        Text("Study Words")
    }
}

#Preview {
    StudyView()
}
