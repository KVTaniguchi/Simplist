import SwiftUI
import SwiftData

@main
struct SimplistApp: App {
    var body: some Scene {
        WindowGroup {
            ListView()
        }
        .modelContainer(SharedAppContainer.shared.container)
    }
}
