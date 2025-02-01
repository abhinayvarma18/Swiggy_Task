//
//  ModelData.swift
//  Swiggy_Task
//
//  Created by abhinay varma on 01/02/25.
//
import SwiftUI
import SwiftData
@MainActor
class ModelData: ObservableObject {
    let container: ModelContainer

    init() {
        let schema = Schema([StockEntity.self]) // Define schema
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            self.container = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    var context: ModelContext {
        container.mainContext
    }
}
