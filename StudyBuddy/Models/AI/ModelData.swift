//
//  ModelData.swift
//  StudyBuddy
//
//  Created by Gustavo Garfias on 04/03/2025.
//

import Foundation
import SwiftUI
import SwiftData

enum Role: String, Codable {
    case assistant
    case user
    case system
}

@Model
class Message {
    @Attribute(.unique) var id: UUID
    var role: Role
    var content: String
    var timestamp: Date
    var generatingTime: TimeInterval?

    @Relationship(inverse: \Thread.messages) var thread: Thread?

    init(role: Role, content: String, thread: Thread? = nil, generatingTime: TimeInterval? = nil) {
        self.id = UUID()
        self.role = role
        self.content = content
        self.timestamp = Date()
        self.thread = thread
        self.generatingTime = generatingTime
    }
}

@Model
final class Thread: Sendable {
    @Attribute(.unique) var id: UUID
    var title: String?
    var timestamp: Date

    @Relationship var messages: [Message] = []

    var sortedMessages: [Message] {
        return messages.sorted { $0.timestamp < $1.timestamp }
    }

    init() {
        self.id = UUID()
        self.timestamp = Date()
    }
}
