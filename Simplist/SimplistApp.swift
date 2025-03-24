import SwiftUI
import SwiftData

@main
struct SimplistApp: App {
    var body: some Scene {
        WindowGroup {
            ListView(modelContext: SharedAppContainer.shared.container.mainContext)
        }
        .modelContainer(SharedAppContainer.shared.container)
    }
}
