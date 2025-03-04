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
    var name: String // File name
    var size: Int // File size in bytes
    var createdAt: Date // File creation date
}
