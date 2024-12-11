//
//  ControlAction.swift
//  AppIntentsJournal
//
//  Created by Celil Çağatay Gedik on 11.12.2024.
//
import AppIntents

struct ComposeControlAction: AppIntent {
    static let title: LocalizedStringResource = "Compose Journal Entry"
    
    static var isDiscoverable = false
    
    func perform() async throws -> some IntentResult & OpensIntent {
        return .result(opensIntent: ComposeNewJournalEntry())
    }
}
