//
//  JournalEntryEntity.swift
//  AppIntentsJournal
//
//  Created by Celil Çağatay Gedik on 11.12.2024.
//

import AppIntents
import CoreLocation
import CoreSpotlight

@AssistantEntity(schema: .journal.entry)
struct JournalEntryEntity: IndexedEntity {
    static let defaultQuery = JournalQuery()
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(stringLiteral: title ?? "No Title")
    }
    
    let id: UUID
    
    var title: String?
    var message: AttributedString?
    var mediaItems: [IntentFile]
    
    var entryDate: Date?
    var location: CLPlacemark?
    var mood: DeveloperStateOfMind?
    
    init(item: JournalEntry) {
        id = item.journalID
        title = item.title
        entryDate = item.entryDate
        message = item.message?.asAttributedString
        mood = item.stateOfMind
    }
}

struct JournalQuery: EntityQuery {
    @MainActor
    func entities(for identifiers: [JournalEntryEntity.ID]) async throws -> [JournalEntryEntity] {
        let entries = try await DataModelHelper.journalEntries(for: identifiers)
        return entries.map(\.entity)
    }
    
    func suggestedEntities() async throws -> [JournalEntryEntity] {
        let entries = try await DataModelHelper.journalEntries(limit: 5)
        return entries.map(\.entity)
    }
}

extension JournalEntryEntity {
    var attributeSet: CSSearchableItemAttributeSet {
        let attributeSet = defaultAttributeSet
        attributeSet.title = title
        if let message {
            attributeSet.contentDescription = String(message.characters[...])
        }
        return attributeSet
    }
}



