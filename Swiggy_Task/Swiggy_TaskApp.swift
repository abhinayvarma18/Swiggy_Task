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
    @StateObject private var modelData = ModelData()
    @StateObject var router = NavigationRouter()
    var body: some Scene {
        WindowGroup {
            StockListingView(modelData.context)
                .environmentObject(modelData)
                .environmentObject(router)
        }
        .modelContainer(modelData.container)
    }
}
