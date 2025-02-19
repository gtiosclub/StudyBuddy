//
//  SetView.swift
//  StudyBuddy
//
//  Created by Jihoon Kim on 2/11/25.
//

import SwiftUI

struct SetView: View {
    var hardcodedSet: [String: String] = ["Hello": "World", "Swift": "UI", "SwiftUI": "Is"]

    var body: some View {
        Text("View All the Words")
    }
}

#Preview {
    SetView()
}
