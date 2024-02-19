//
//  Item.swift
//  Simplist
//
//  Created by Kevin Taniguchi on 2/19/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
