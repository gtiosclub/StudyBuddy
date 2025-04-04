import Foundation
import FirebaseFirestore

class StudySetModel: ObservableObject, Identifiable, Codable {
    @DocumentID var id: String?
    @Published var flashcards: [FlashcardModel]
    var dateCreated: Date
    var createdBy: String

    enum CodingKeys: String, CodingKey {
        case id
        case flashcards
        case dateCreated
        case createdBy
    }

    init(flashcards: [FlashcardModel], dateCreated: Date, createdBy: String) {
        self.flashcards = flashcards
        self.dateCreated = dateCreated
        self.createdBy = createdBy
    }

    // Custom decoder to handle @Published properties
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        // Decode the underlying array and assign it to the @Published property
        flashcards = try container.decode([FlashcardModel].self, forKey: .flashcards)
        dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        createdBy = try container.decode(String.self, forKey: .createdBy)
    }

    // Custom encoder to handle @Published properties
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        // Encode the underlying flashcards array
        try container.encode(flashcards, forKey: .flashcards)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(createdBy, forKey: .createdBy)
    }
}
