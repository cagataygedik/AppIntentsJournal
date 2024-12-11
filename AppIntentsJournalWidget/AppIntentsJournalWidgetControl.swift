//
//  AppIntentsJournalWidgetControl.swift
//  AppIntentsJournalWidget
//
//  Created by Celil Çağatay Gedik on 11.12.2024.
//

import AppIntents
import SwiftUI
import WidgetKit

struct AppIntentsJournalWidgetControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(
            kind: "com.apple-samplecode.AppIntentsJournal--SAMPLE-CODE-DISAMBIGUATOR-.AppIntentsJournalWidget") {
                ControlWidgetButton(action: ComposeControlAction()) {
                    Label("Create Entry", systemImage: "rectangle.and.pencil.and.ellipsis")
                }
            }
        .displayName("Compose")
        .description("A control that starts writing a new journal entry.")
    }
}
