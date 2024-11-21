import Foundation
import AppIntents
import SwiftData
import WidgetKit
import SwiftUI

struct SharedItem: Identifiable {
    let name: String
    let id: String
    let completed: Bool
    
    var imageName: String {
        completed ? "circle.circle.fill" : "circle"
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let items: [SharedItem]
}

struct SimplistIntent: AppIntent {
    static var title: LocalizedStringResource = "Simplist Intent"
    
    @Parameter(title: "Simplist id")
    var modelId: String
    
    init(modelId: String) {
        self.modelId = modelId
    }
    
    init() {}
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let predicate = #Predicate<Item> { item in
            item.uuid == modelId
        }
        
        if let item = try SharedAppContainer.shared.container.mainContext.fetch(.init(predicate: predicate)).first {
            item.completed = true
            try SharedAppContainer.shared.container.mainContext.save()
        }
        
        return .result()
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), items: [SharedItem(name: "placeholder", id: UUID().uuidString, completed: false)])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), items: [SharedItem(name: "placeholder", id: UUID().uuidString, completed: false)])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        Task { @MainActor in
            var entries: [SimpleEntry] = []
            
            let context = SharedAppContainer.shared.container.mainContext
            
            let items = (try? context.fetch(FetchDescriptor<Item>())) ?? []
            
            let simpleItems = items
                .sorted(by: { ($0.ordinal ?? 0) < ($1.ordinal ?? 0) })
                .map { SharedItem(name: $0.name ?? "no name???", id: $0.uuid, completed: $0.completed) }
            
            entries.append(SimpleEntry(date: Date(), items: simpleItems.filter { !$0.completed }))
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            
            completion(timeline)
        }
    }
}


struct SimplistWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Simplist")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding([.top, .bottom], 8)
            ForEach(entry.items.prefix(7), id: \.id) { item in
                HStack {
                    Button(
                        item.name,
                        systemImage: item.imageName,
                        intent: SimplistIntent(modelId: item.id)
                    )
                    .buttonStyle(.automatic)
                    Spacer()
                }
            }
            Spacer()
        }
        .transition(.push(from: .bottom))
    }
}

struct SimplistWidget: Widget {
    let kind: String = "Simplist_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            return SimplistWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Simplist")
        .description("Simplist widget")
        .supportedFamilies([
            .systemLarge
        ])
    }
}
