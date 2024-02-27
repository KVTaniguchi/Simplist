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
    var checklist: Checklist?
    var completed: Bool = false
    
    public init() {}
}