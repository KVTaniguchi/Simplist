//
//  Simplist_WidgetBundle.swift
//  Simplist Widget
//
//  Created by Kevin Taniguchi on 2/29/24.
//

import WidgetKit
import SwiftUI
import SwiftData

@main
struct Simplist_WidgetBundle: WidgetBundle {
    var body: some Widget {
        Simplist_Widget()
        Simplist_WidgetLiveActivity()
    }
}
