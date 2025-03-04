//
//  FileModel.swift
//  StudyBuddy
//
//  Created by alina on 2025/3/3.
//

// FileModel.swift
import Foundation

struct FileModel: Identifiable {
    let id = UUID() // Unique identifier for each file
    let name: String // File name
    let size: Int // File size in bytes
    let createdAt: Date // File creation date
}
