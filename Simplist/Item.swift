//
//  Item.swift
//  Simplist
//
//  Created by Kevin Taniguchi on 2/19/24.
//

import Foundation
import SwiftData

@Model
final public class Item {
    var timestamp: Date = Date()
    var name: String?
    var ordinal: Int?
    var completed: Bool = false
    let uuid = UUID().uuidString
    
    public init() {}
}
