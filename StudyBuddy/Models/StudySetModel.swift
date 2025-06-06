import Foundation
import FirebaseFirestore
class StudySetModel: Identifiable, Codable {
    @DocumentID var id: String?
    var flashcards: [FlashcardModel]
    var dateCreated: Date
    var createdBy: String
    var name: String
    var documentIDs: [String]
    var flashcardIDs: [String]? = []

    init(flashcards: [FlashcardModel], dateCreated: Date, createdBy: String, name: String, documentIDs: [String] = [], flashcardIDs: [String] = []) {
        self.flashcards = flashcards
        self.dateCreated = dateCreated
        self.createdBy = createdBy
        self.name = name
        self.documentIDs = documentIDs
        self.flashcardIDs = flashcardIDs
    }
}
