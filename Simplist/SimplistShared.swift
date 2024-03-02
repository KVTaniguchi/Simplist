//
//  SimplistEntryView.swift
//  Simplist
//
//  Created by Kevin Taniguchi on 3/2/24.
//

import Foundation
import AppIntents
import SwiftData
import WidgetKit
import SwiftUI

struct SharedItem: Identifiable {
    let name: String
    let id: String
    let completed: Bool
    
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
    
    func perform() async throws -> some IntentResult {
        let predicate = #Predicate<Item> { item in
            item.name == modelId
        }
        
        if let item = try? await SharedAppContainer.shared.container.mainContext.fetch(.init(predicate: predicate)).first {
            item.completed = true
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
            
            print("getting timeline")
            print(items)
            
            let simpleItems = items.map { SharedItem(name: $0.name ?? "", id: UUID().uuidString, completed: false) }
            
            entries.append(SimpleEntry(date: Date(), items: simpleItems.filter { $0.completed }))
            entries.append(SimpleEntry(date: Date().addingTimeInterval(0.5), items: simpleItems.filter { !$0.completed }))
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            
            completion(timeline)
        }
    }
}


struct SimplistWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.items.first?.name ?? "")
            Text(entry.items.last?.name ?? "")
        }
    }
}

struct SimplistWidget: Widget {
    let kind: String = "Simplist_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            print(entry)
            return SimplistWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Simplist")
        .description("Simplist widget")
    }
}
