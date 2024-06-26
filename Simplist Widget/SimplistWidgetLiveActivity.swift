//
//  Simplist_WidgetLiveActivity.swift
//  Simplist Widget
//
//  Created by Kevin Taniguchi on 2/29/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Simplist_WidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

//struct SimplistWidget: Widget {
//    let kind: String = "Simplist_Widget"
//
//    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            return SimplistWidgetEntryView(entry: entry)
//                .containerBackground(.fill.tertiary, for: .widget)
//        }
//        .configurationDisplayName("Simplist")
//        .description("Simplist widget")
//        .supportedFamilies([
//            .systemLarge
//        ])
//    }
//}

struct SimplistWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Simplist_WidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension Simplist_WidgetAttributes {
    fileprivate static var preview: Simplist_WidgetAttributes {
        Simplist_WidgetAttributes(name: "World")
    }
}

extension Simplist_WidgetAttributes.ContentState {
    fileprivate static var smiley: Simplist_WidgetAttributes.ContentState {
        Simplist_WidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: Simplist_WidgetAttributes.ContentState {
         Simplist_WidgetAttributes.ContentState(emoji: "🤩")
     }
}
