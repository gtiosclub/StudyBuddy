//
//  DocumentsModel.swift
//  StudyBuddy
//
//  Created by Krish Kapoor on 20/02/2025.
//
import Foundation
enum DocumentType: String, Codable {
    case file
    case folder
}
/// Represents a document in the StudyBuddy app.
/// Stores the document name, raw content, parsed content (if available), and creation date.
struct Document: Identifiable, Codable {
    let id: UUID  // Unique identifier for each document
    let fileName: String  // Name of the document file
    let content: String  // Raw content of the document
    let dateCreated: Date  // Timestamp when the document was created
    var parsedContent: String?  // Stores extracted text after parsing (optional)
    var fileData: Data? // Data of the Document for file storage needs
    var fileURL: String? // URL to download from Cloud Storage (for files)
    var type: DocumentType = .file // .file or .folder, default to file
    var isFavorite: Bool = false // For the favorites feature
    var firestoreDocumentId: String? // To store the Firestore document ID
    var userID: String // firebase's UID
    var isPrivate: Bool
    /// Initializes a new document with a given file name and content.
    /// - Parameters:
    ///   - fileName: Name of the document file.
    ///   - content: Raw text content of the document.
    ///   - parsedContent: Extracted text content after processing (default: nil).
    ///   - fileData: Data of the document (default: nil).
    init(fileName: String, content: String, parsedContent: String? = nil,
         fileData: Data? = nil, fileURL: String? = nil,
         type: DocumentType = .file, isFavorite: Bool = false, userID: String, isPrivate: Bool) {
        self.id = UUID()  // Generate a unique ID
        self.fileName = fileName
        self.content = content
        self.dateCreated = Date()  // Set creation timestamp
        self.parsedContent = parsedContent
        self.fileData = fileData
        self.fileURL = fileURL
        self.type = type
        self.isFavorite = isFavorite
        self.firestoreDocumentId = nil // Initialize as nil
        self.userID = userID
        self.isPrivate = isPrivate
        
    }
    /// Updates the parsed content of the document after text extraction.
    /// - Parameter parsed: The extracted text from the document.
    mutating func updateParsedContent(_ parsed: String) {
        self.parsedContent = parsed
    }
}
// Example usage:
/*
 // Creating a document instance
 var document = Document(fileName: "lecture.pdf", content: "raw content")
 // Parsing text from a PDF and updating parsed content
 extractTextFromPDF(pdfURL: url) { parsedText in
     document.updateParsedContent(parsedText)
 }
*/

