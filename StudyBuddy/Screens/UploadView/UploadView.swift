//
//  UploadView.swift
//  StudyBuddy
//
//  Created by Tony Nguyen on 2/11/25.
//

import SwiftUI

struct UploadView: View {
    @StateObject var uploadViewModel = UploadViewModel()
    @State private var isPickerPresented = false

    var body: some View {
        VStack {
            Button(action: {
                isPickerPresented = true
            }, label: {
                Text("Select Document")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            })

            if !uploadViewModel.selectedDocumentNames.isEmpty {
                VStack(alignment: .leading) {
                    Text("Selected Documents:")
                        .font(.headline)

                    ForEach(uploadViewModel.selectedDocumentNames, id: \.self) { document in
                        Text(document)
                            .padding(5)
                    }
                }
                .padding()
            }
        }
        .padding()
        .sheet(isPresented: $isPickerPresented) {
            DocumentPickerView(uploadViewModel: uploadViewModel)
        }
    }
}
