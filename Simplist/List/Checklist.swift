//
//  List.swift
//  Simplist
//
//  Created by Kevin Taniguchi on 2/19/24.
//

import Foundation
import SwiftData

@Model
final public class Checklist {
    var name: String?
    var ordinal: Int?
    
    public init() {}
    
    var order: Int {
        if let ordinal = ordinal {
            return ordinal
        } else {
            return 0
        }
    }
}
