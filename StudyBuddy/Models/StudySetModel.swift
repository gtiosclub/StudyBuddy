import Foundation
import FirebaseFirestore
class StudySetModel: Identifiable, Codable {
    @DocumentID var id: String?
    var flashcards: [FlashcardModel]
    var dateCreated: Date
    var createdBy: String
    var name: String
    var documentIDs: [String]
    //create multiple study sets and initialize it with values
}
