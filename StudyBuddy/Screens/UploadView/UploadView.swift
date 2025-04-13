//
//  UploadView.swift
//  StudyBuddy
//
//  Created by Tony Nguyen on 2/11/25.
//
import SwiftUI

struct UploadView: View {
    @ObservedObject var uploadViewModel: UploadViewModel
    @State private var isPublic = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 30) {
            if !uploadViewModel.selectedDocumentNames.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Selected Documents:")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    ForEach(uploadViewModel.selectedDocumentNames, id: \.self) { document in
                        Text(document)
                            .padding(8)
                            .font(.body)
                            .background(Color(hex: "#71569E"))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color(hex: "#71569E").opacity(0.3))
                .cornerRadius(12)
            }

            Text("Select Privacy")
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .padding(.top)

            HStack {
                Text("Private")
                    .foregroundColor(.white)
                    .bold()
                    .font(.title3)

                Toggle("", isOn: $isPublic)
                    .toggleStyle(SwitchToggleStyle(tint: .green))
                    .labelsHidden()

                Text("Public")
                    .foregroundColor(.green)
                    .bold()
                    .font(.title3)
            }
            .padding()

            Button(action: {
                for document in uploadViewModel.documents {
                    var doc: Document = document
                    doc.isPrivate = !isPublic

                    // update call to upload the file to Firebase

                    uploadViewModel.uploadFileToFirebase(
                        fileName: document.fileName,
                        fileData: document.fileData!,
                        document: doc,
                        isPublic: isPublic
                    )
                }

                // Close the view and reset flags
                print("Uploaded")
                presentationMode.wrappedValue.dismiss()
                uploadViewModel.isUploadPresented = false
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Upload Files")
                }
                .font(.title3)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .foregroundColor(.white)
                .background(Color(hex: "#6213D0"))
                .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "#321C58").edgesIgnoringSafeArea(.all))
    }
}

//extension Color {
//    init(hex: String) {
//        let scanner = Scanner(string: hex.trimmingCharacters(in: .whitespacesAndNewlines))
//        scanner.currentIndex = hex.startIndex
//
//        var rgb: UInt64 = 0
//        scanner.scanString("#", into: nil)
//        scanner.scanHexInt64(&rgb)
//
//        let r = Double((rgb >> 16) & 0xFF) / 255
//        let g = Double((rgb >> 8) & 0xFF) / 255
//        let b = Double(rgb & 0xFF) / 255
//
//        self.init(red: r, green: g, blue: b)
//    }
//}
