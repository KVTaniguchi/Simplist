//
//  Simplist_Widget.swift
//  Simplist Widget
//
//  Created by Kevin Taniguchi on 2/29/24.
//

import WidgetKit
import SwiftData
import SwiftUI

struct Provider: TimelineProvider {
    @Environment(\.modelContext) var modelContext: ModelContext
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), item: "placeholder")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), item: "placeholder")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries: [SimpleEntry] = []
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let item: String
}

struct Simplist_WidgetEntryView : View {
    var entry: Provider.Entry
    
//    var imageName: String {
//        entry.item.completed ? "circle.circle.fill" : "circle"
//    }

    var body: some View {
        Button {
            withAnimation {
//                entry.item.completed.toggle()
            }
            
//            try? entry.item.modelContext?.save()
        } label: {
            HStack {
                Image(systemName: "circle")
                    .animation(.easeInOut(duration: 0.2))
                Text("placeholder")
                    .foregroundColor(.primary)
            }
        }
    }
}

struct Simplist_Widget: Widget {
    let kind: String = "Simplist_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                Simplist_WidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                Simplist_WidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
