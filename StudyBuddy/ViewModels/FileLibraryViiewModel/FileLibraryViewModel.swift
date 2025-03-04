//
//  FileLibraryViewModel.swift
//  StudyBuddy
//
//  Created by Tony Nguyen on 2/27/25.
//
import Foundation

class FileLibraryViewModel: ObservableObject {
    @Published var fileLibrary: [String] = ["Document1.pdf", "Image1.png", "Report.docx"]
}
