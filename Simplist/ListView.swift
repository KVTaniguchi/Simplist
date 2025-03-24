import SwiftUI
import SwiftData

struct ListView: View {
    @State private var viewModel: ListViewModel
    
    init(modelContext: ModelContext) {
        _viewModel = State(initialValue: ListViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Active Items Section
                Section {
                    ForEach(viewModel.notCompletedItems) { item in
                        ListRowView(item: item)
                            .onTapGesture {
                                viewModel.toggleCompletion(for: item)
                            }
                    }
                    .onMove { source, destination in
                        viewModel.moveItems(source, destination)
                    }
                    .onDelete { indexSet in
                        viewModel.deleteItems(indexSet, from: .active)
                    }
                }
                
                // Completed Items Section
                if !viewModel.completedItems.isEmpty {
                    Section("Completed") {
                        ForEach(viewModel.completedItems) { item in
                            ListRowView(item: item)
                                .onTapGesture {
                                    viewModel.toggleCompletion(for: item)
                                }
                        }
                        .onDelete { indexSet in
                            viewModel.deleteItems(indexSet, from: .completed)
                        }
                    }
                }
            }
            .navigationTitle("Simplist")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { viewModel.showAddItem() }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
        }
        .sheet(isPresented: .init(
            get: { viewModel.isShowingAddItemView },
            set: { if !$0 { viewModel.hideAddItem() }}
        )) {
            AddItemView(isShowingAddItemView: .init(
                get: { viewModel.isShowingAddItemView },
                set: { if !$0 { viewModel.hideAddItem() }}
            ))
        }
    }
}
