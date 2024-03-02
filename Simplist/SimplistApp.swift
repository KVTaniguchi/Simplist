//
//  SimplistApp.swift
//  Simplist
//
//  Created by Kevin Taniguchi on 2/19/24.
//

import SwiftUI
import SwiftData

@main
struct SimplistApp: App {
    var body: some Scene {
        WindowGroup {
            TabBarView()
        }
        .modelContainer(sharedModelContainer)
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Checklist.self,
            Item.self,
        ])
        let m = ModelConfiguration(
            "SimplistAppModelConfig",
            schema: schema,
            isStoredInMemoryOnly: false,
            allowsSave: true,
            groupContainer: .identifier("group.simplist")
        )
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [m])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}
