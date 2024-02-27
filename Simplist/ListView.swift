//
//  ContentView.swift
//  Simplist
//
//  Created by Kevin Taniguchi on 2/19/24.
//

import SwiftUI
import SwiftData

struct ListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isShowingAddItemView: Bool = false
    @State private var activelist: Checklist?
    @State private var isShowingAddList: Bool = false
    @Query(
        sort: \Checklist.ordinal
    ) var lists: [Checklist]
    @Query(
        sort: \Item.ordinal
    )
    var items: [Item]
    
    var notCompletedItems: [Item] {
        items
            .filter { $0.checklist?.order == 0 }
            .filter { !$0.completed }
    }
    
    var completedItems: [Item] {
        items
            .filter { $0.checklist?.order == 0 }
            .filter { $0.completed }
    }

    var body: some View {
        List {
            Section {
                ForEach(notCompletedItems) { item in
                    ListRowView(item: item)
                }
                .onMove(perform: moveItem)
                .onDelete(perform: deleteItems)
            }
            Section {
                ForEach(completedItems) { item in
                    ListRowView(item: item)
                }
                .onMove(perform: moveItem)
                .onDelete(perform: deleteItems)
            }
            
        }
        .sheet(isPresented: $isShowingAddList) {
            AddListView(
                isShowingAddListView: $isShowingAddList
            )
            .environment(\.modelContext, modelContext)
        }
        .sheet(isPresented: $isShowingAddItemView) {
            AddItemView(checkList: lists.first, isShowingAddItemView: $isShowingAddItemView)
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

    private func addItem() {
        isShowingAddItemView.toggle()
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    
    private func moveItem(from source: IndexSet, to destination: Int) {
        var itemsCopy = items
        itemsCopy.move(fromOffsets: source, toOffset: destination)
        
        for (index, itemCopy) in itemsCopy.enumerated() {
            if let item = items.first(where: { $0 == itemCopy }) {
                item.ordinal = index
            }
            
        }
    }
}

#Preview {
    ListView()
        .modelContainer(for: Item.self, inMemory: true)
}
