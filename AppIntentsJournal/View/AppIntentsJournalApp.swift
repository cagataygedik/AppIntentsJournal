/*
See LICENSE folder for this sample’s licensing information.

Abstract: The main app structure.

*/

import SwiftUI
import AppIntents

@main
struct AppIntentsJournalApp: App {
    let modelContainer = DataModel.shared.modelContainer
    let navigationManager: NavigationManager
    
    init() {
        let navigationManager = NavigationManager()
        self.navigationManager = navigationManager
        AppDependencyManager.shared.add(dependency: navigationManager)
    }
    
    var body: some Scene {
        WindowGroup {
            JournalListView()
        }
        .modelContainer(modelContainer)
        .environment(navigationManager)
    }
}
