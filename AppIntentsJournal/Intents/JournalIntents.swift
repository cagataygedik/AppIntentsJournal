//
//  JournalIntents.swift
//  AppIntentsJournal
//
//  Created by Celil Çağatay Gedik on 11.12.2024.
//

import AppIntents
import CoreLocation
import CoreSpotlight

enum IntentError: Error {
    case noEntity
}

@AssistantIntent(schema: .journal.createEntry)
struct CreateJournalEntryIntent {
    var message: AttributedString
    var title: String?
    var entryDate: Date?
    var location: CLPlacemark?
    
    @Parameter(default: [])
    var mediaItems: [IntentFile]
    
    @Parameter(title: "State of Mind")
    var mood: DeveloperStateOfMind?
    
    func perform() async throws -> some ReturnsValue<JournalEntryEntity> {
        do {
            let entry = try DataModelHelper.newEntry(title: title, message: message, entryDate: entryDate, stateOfMind: mood)
            
            try? await CSSearchableIndex.default().indexAppEntities([entry.entity])
            
            return .result(value: entry.entity)
        } catch {
            throw IntentError.noEntity
        }
    }
}

@AssistantIntent(schema: .journal.search)
struct SearchJournalEntriesIntent: ShowInAppSearchResultsIntent {
    static var searchScopes: [StringSearchScope] = [.general]
    
    var criteria: StringSearchCriteria
    
    @Dependency
    var navigationManager: NavigationManager
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let searchString = criteria.term
        navigationManager.openSearch(with: searchString)
        return .result()
    }
}
