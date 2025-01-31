//
//  Swiggy_TaskApp.swift
//  Swiggy_Task
//
//  Created by abhinay varma on 31/01/25.
//

import SwiftUI
import SwiftData

@main
struct Swiggy_TaskApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            StockEntity.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            StockListingView(modelContext: ModelContext(sharedModelContainer))
        }
        .modelContainer(sharedModelContainer)
    }
}
