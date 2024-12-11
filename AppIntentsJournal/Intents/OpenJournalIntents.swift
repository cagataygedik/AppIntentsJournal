//
//  OpenJournalIntents.swift
//  AppIntentsJournal
//
//  Created by Celil Çağatay Gedik on 11.12.2024.
//

import AppIntents


struct OpenJournalIntents: OpenIntent {
    static var title: LocalizedStringResource = "Open Journal Entry"
    static var description = IntentDescription("Shows the details for a specific journal entry.")
    
    @Parameter(title: "Journal Entry")
    var target: JournalEntryEntity
    
    @Dependency
    private var navigationManager: NavigationManager
    
    @MainActor
    func perform() async throws -> some IntentResult {
        do {
            let entityID = target.id
            let entries = try await DataModelHelper.journalEntries(for: [entityID])
            guard let entry = entries.first else {
                throw IntentError.noEntity
            }
            navigationManager.openJournalEntry(entry)
            return .result()
        } catch {
            throw IntentError.noEntity
        }
    }
}

struct ComposeNewJournalEntry: AppIntent {
    static var title: LocalizedStringResource = "Compose Journal Entry"
    static var description = IntentDescription("Opens the app and starts composing a new journal entry.")

    @Dependency
    private var navigationManager: NavigationManager
    
    static var openAppWhenRun: Bool = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        navigationManager.composeNewJournalEntry()
        return .result()
    }
}

