//
//  AddListView.swift
//  Simplist
//
//  Created by Kevin Taniguchi on 2/19/24.
//

import SwiftUI
import SwiftData
import WidgetKit

struct AddListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var listName: String = ""
    @State private var newItemName: String = ""
    @State private var newItems = [String]()
    @Binding var isShowingAddListView: Bool
    @Query(
        sort: \Checklist.ordinal
    ) var lists: [Checklist]
    
    var body: some View {
        NavigationView {
            VStack {
                toolBar
                
                form
            }
        }
    }
    
    private var toolBar: some View {
        HStack(spacing: 0) {
            Button("Cancel") {
                isShowingAddListView = false
            }
            .frame(maxWidth: .infinity)
            Button("Save") {
                addItem()
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
    
    private var form: some View {
        Form {
            Section("List name") {
                TextEditor(text: $listName)
            }
            Section("New item") {
                TextField("Name", text: $newItemName)
                Button("Add item") {
                    newItems.insert(newItemName, at: 0)
                }
                .disabled(newItemName.isEmpty)
            }
            Section("Items") {
                List(newItems, id: \.self) {
                    Text($0)
                }
            }
        }
    }
    
    private func addItem() {
        let newList = Checklist()
        newList.name = listName
        if let highestOrdinal = lists.last?.ordinal {
            newList.ordinal = highestOrdinal + 1
        }
        modelContext.insert(newList)
        
        for (index, newItemName) in newItems.enumerated() {
            let newItem = Item()
            newItem.name = newItemName
            newItem.ordinal = index
            newItem.checklist = newList
            modelContext.insert(newItem)
        }
        try? newList.modelContext?.save()
        
        isShowingAddListView.toggle()
        
        WidgetCenter.shared.reloadAllTimelines()
    }
}
