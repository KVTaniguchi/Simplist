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
        .modelContainer(SharedAppContainer.shared.container)
    }
}
