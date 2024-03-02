//
//  SharedAppContainer.swift
//  Simplist
//
//  Created by Kevin Taniguchi on 3/2/24.
//

import Foundation
import SwiftData

final class SharedAppContainer {
    static let shared = SharedAppContainer()
    
    private init () {}
    
    var container: ModelContainer = {
        let schema = Schema([
            Checklist.self,
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}
