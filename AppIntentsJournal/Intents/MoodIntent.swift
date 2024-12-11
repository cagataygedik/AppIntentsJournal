//
//  MoodIntent.swift
//  AppIntentsJournal
//
//  Created by Celil Çağatay Gedik on 11.12.2024.
//

import AppIntents
import CoreSpotlight
import SwiftUI

struct MoodIntent: AppIntent {
    static var title: LocalizedStringResource = "Mood Check-In"
    static var description = IntentDescription("Adds a mood entry to the journal.")
    
    @Parameter(title: "State of Mind")
    var mood: DeveloperStateOfMind
    
    func perform() async throws -> some ProvidesDialog & ShowsSnippetView & ReturnsValue<JournalEntryEntity> {
        do {
            let entry = try DataModelHelper.newEntry(stateOfMind: mood)
            
            try? await CSSearchableIndex.default().indexAppEntities([entry.entity])
            
            let dialog = IntentDialog(full: "I created a new journal entry for you.", supporting: "All Done.")
            return .result(value: entry.entity, dialog: dialog) {
                VStack {
                    Text(mood.symbol())
                        .font(.system(size: 64))
                        .frame(width: 96, height: 96)
                        .background(mood.accentColor(), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .padding()
                }
            }
        } catch {
            throw IntentError.noEntity
        }
    }
}
