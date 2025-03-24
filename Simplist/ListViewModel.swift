import SwiftUI
import SwiftData

@Observable
final class ListViewModel {
    // MARK: - Properties
    private let modelContext: ModelContext
    var items: [Item] = []
    private(set) var isShowingAddItemView = false
    
    // MARK: - Computed Properties
    var notCompletedItems: [Item] {
        fetchItems() // should this be removed?
        return items.filter { !$0.completed }
    }
    
    var completedItems: [Item] {
        fetchItems() // should this be removed?
        return items.filter { $0.completed }
    }
    
    // MARK: - Initialization
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchItems()
    }
    
    // MARK: - Data Operations
    private func fetchItems() {
        let descriptor = FetchDescriptor<Item>(
            sortBy: [SortDescriptor(\Item.ordinal, order: .forward)]
        )
        
        do {
            items = try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching items: \(error)")
            items = []
        }
    }
    
    // MARK: - Actions
    func showAddItem() {
        isShowingAddItemView = true
    }
    
    func hideAddItem() {
        isShowingAddItemView = false
    }
    
    func deleteItems(_ indexSet: IndexSet, from section: ItemSection) {
        let itemsToDelete = indexSet.map { index in
            switch section {
            case .active:
                return notCompletedItems[index]
            case .completed:
                return completedItems[index]
            }
        }
        
        itemsToDelete.forEach { item in
            modelContext.delete(item)
        }
        
        fetchItems() // Refresh the items array
    }
    
    func moveItems(_ source: IndexSet, _ destination: Int) {
        var updatedItems = notCompletedItems
        updatedItems.move(fromOffsets: source, toOffset: destination)
        
        // Update ordinals to reflect new order
        for (index, item) in updatedItems.enumerated() {
            item.ordinal = index
        }
        
        try? modelContext.save()
        fetchItems() // Refresh the items array
    }
    
    func toggleCompletion(for item: Item) {
        item.completed.toggle()
        try? modelContext.save()
        fetchItems() // Refresh the items array
    }
}

// MARK: - Supporting Types
extension ListViewModel {
    enum ItemSection {
        case active
        case completed
    }
}
