
import Foundation
import SwiftData

@Model
final public class Item {
    var timestamp: Date = Date()
    var name: String?
    var ordinal: Int?
    var completed: Bool = false
    var uuid = UUID().uuidString
    
    public init() {}
}
