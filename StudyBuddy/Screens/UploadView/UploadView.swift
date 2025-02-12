//
//  UploadView.swift
//  StudyBuddy
//
//  Created by Tony Nguyen on 2/11/25.
//

import Foundation

import SwiftUI

struct UploadView: View {
    @StateObject var uploadViewModel: UploadViewModel = UploadViewModel()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    UploadView()
}
