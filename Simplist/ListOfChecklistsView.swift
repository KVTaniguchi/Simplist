//
//  ListOfChecklistsView.swift
//  Simplist
//
//  Created by Kevin Taniguchi on 2/19/24.
//

import SwiftUI
import SwiftData

struct ListOfChecklistsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var checklists: [Checklist]
    @State private var showingAddNewList: Bool = false
    @Query var items: [Item]
    
    var lists: [Checklist] {
        checklists.sorted(by: { $0.order < $1.order} )
    }
    
    var body: some View {
        List {
            ForEach(lists) { checklist in
                Text(line(checkList: checklist))
            }
            .onDelete(perform: deleteLists)
            .onMove { indexSet, index in
                move(indexSet: indexSet, index: index)
            }
        }
        .toolbar {
            ToolbarItem {
                Button(action: addList) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddNewList) {
            AddListView(isShowingAddListView: $showingAddNewList)
        }
        
    }
    
    private func move(indexSet: IndexSet, index: Int) {
        var listsCopy = checklists
        listsCopy.move(fromOffsets: indexSet, toOffset: index)
        
        for (index, listCopy) in listsCopy.enumerated() {
            if let listToReorder = checklists.first(where: { $0 === listCopy }) {
                listToReorder.ordinal = index
            }
        }
    }
    
    private func line(checkList: Checklist) -> String {
        let numberOfItemsInList = items.filter({ $0.checklist == checkList }).count
        let name = checkList.name ?? "no name"
        return name + ":  " + "\(numberOfItemsInList)" + " " + "\(checkList.order)"
    }
    
    private func addList() {
        showingAddNewList.toggle()
    }
    
    private func deleteLists(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(checklists[index])
            }
        }
    }
}
