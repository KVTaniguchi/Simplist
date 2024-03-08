//
//  ContentView.swift
//  Simplist
//
//  Created by Kevin Taniguchi on 2/19/24.
//

import SwiftUI
import SwiftData
import WidgetKit

struct ListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isShowingAddItemView: Bool = false
    @Query(
        sort: \Item.ordinal
    )
    var items: [Item]
    
    var notCompletedItems: [Item] {
        items.filter { !$0.completed }
    }
    
    var completedItems: [Item] {
        items.filter { $0.completed }
    }

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(notCompletedItems) { item in
                        ListRowView(item: item)
                    }
                    .onMove(perform: moveItem)
                    .onDelete(perform: deleteItems)
                    // add new button that just adds a new text
                }
                
                if !completedItems.isEmpty {
                    Section {
                        ForEach(completedItems) { item in
                            ListRowView(item: item)
                        }
                        .onMove(perform: moveItem)
                        .onDelete(perform: deleteItems)
                        Button("Delete all completed", role: .destructive) {
                            deleteAllCompleted()
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingAddItemView) {
                AddItemView(isShowingAddItemView: $isShowingAddItemView)
                    .presentationDetents([.fraction(0.15)])
            }
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func addItem() {
        isShowingAddItemView.toggle()
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func deleteAllCompleted() {
        let completedItems = self.completedItems
        
        for completedItem in completedItems {
            modelContext.delete(completedItem)
        }
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func moveItem(from source: IndexSet, to destination: Int) {
        var itemsMovable = notCompletedItems
        itemsMovable.move(fromOffsets: source, toOffset: destination)
        
        for (index, itemCopy) in itemsMovable.enumerated() {
            if let item = items.first(where: { $0 == itemCopy }) {
                item.ordinal = index
            }
        }
        
        WidgetCenter.shared.reloadAllTimelines()
    }
}

#Preview {
    ListView()
        .modelContainer(for: Item.self, inMemory: true)
}
