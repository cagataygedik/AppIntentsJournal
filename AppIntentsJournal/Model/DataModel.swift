/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
An actor that provides a SwiftData model container for the whole app and widget,
 and implements actor-isolated tasks like SwiftData history processing.
*/

import SwiftUI
import SwiftData

actor DataModel {
    static let shared = DataModel()
    private init() {}
    
    nonisolated lazy var modelContainer: ModelContainer = {
        let modelContainer: ModelContainer
        do {
            modelContainer = try ModelContainer(for: JournalEntry.self)
        } catch {
            fatalError("Failed to create the model container: \(error)")
        }
        return modelContainer
    }()
}

class DataModelHelper {
    
    static func newEntry(title: String? = nil, message: AttributedString? = nil, entryDate: Date? = nil, stateOfMind: DeveloperStateOfMind? = nil) throws -> JournalEntry {
        let modelContext = ModelContext(DataModel.shared.modelContainer)
        let entry = try JournalEntry(title: title, message: JournalMessage(message ?? ""), entryDate: entryDate, stateOfMind: stateOfMind)
        modelContext.insert(entry)
        try modelContext.save()
        return entry
    }
    
    @MainActor
    static func journalEntries(for identifiers: [UUID]) async throws -> [JournalEntry] {
        let modelContext = DataModel.shared.modelContainer.mainContext
        let entries = try modelContext.fetch(FetchDescriptor<JournalEntry>(predicate: #Predicate { identifiers.contains($0.journalID) }))
        return entries
    }

    static func journalEntries(limit: Int) async throws -> [JournalEntry] {
        let modelContext = ModelContext(DataModel.shared.modelContainer)
        var descriptor = FetchDescriptor<JournalEntry>(predicate: #Predicate { _ in true})
        descriptor.fetchLimit = limit
        let entries = try modelContext.fetch(descriptor)
        return entries
    }
}
