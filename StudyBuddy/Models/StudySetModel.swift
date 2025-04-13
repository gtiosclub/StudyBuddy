import Foundation
import FirebaseFirestore
class StudySetModel: Identifiable, Codable {
    @DocumentID var id: String?
    var flashcards: [FlashcardModel]
    var dateCreated: Date
    var createdBy: String

    init(flashcards: [FlashcardModel], dateCreated: Date, createdBy: String) {
        self.flashcards = flashcards
        self.dateCreated = dateCreated
        self.createdBy = createdBy
    }
}
