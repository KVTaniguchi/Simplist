import SwiftUI
import WidgetKit

struct ListRowView: View {
    let item: Item
    @State private var animated = false
    
    var imageName: String {
        item.completed ? "circle.circle.fill" : "circle"
    }
    
    var body: some View {
        Button {
            withAnimation {
                item.completed.toggle()
                animated.toggle()
                WidgetCenter.shared.reloadAllTimelines()
            }
            
            try? item.modelContext?.save()
        } label: {
            HStack {
                Image(systemName: imageName)
                    .animation(.easeInOut(duration: 0.2), value: animated)
                Text(item.name ?? "")
                    .foregroundColor(.primary)
            }
        }
    }
}
