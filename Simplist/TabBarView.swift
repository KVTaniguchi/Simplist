//
//  TabBarView.swift
//  Simplist
//
//  Created by Kevin Taniguchi on 2/19/24.
//

import Foundation
import SwiftUI
import SwiftData

enum TabType {
    case currentList
    case checklists
}

struct TabBarView: View {
    @State private var selectedTab: TabType = .currentList
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                ListView()
                .environment(\.modelContext, modelContext)
            }
            .tabItem {
                Label("Current", systemImage: "list.bullet.clipboard")
            }
            
            NavigationView {
                ListOfChecklistsView().environment(\.modelContext, modelContext)
            }
            .tabItem {
                Label("Lists", systemImage: "list.bullet.below.rectangle")
            }
        }
    }
}
