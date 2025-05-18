

import SwiftUI
import SwiftData

struct MapView: View {
    @Environment(\.modelContext) private var context
    @Query private var stores: [GameDataStore]
    @State private var selectedLevel: Int?

    var body: some View {
      
            if let store = stores.first {
                List {
                    ForEach(store.levels) { level in
                        NavigationLink(
                            destination: DecryptionGameView(levelID: level.id),
                            tag: level.id,
                            selection: $selectedLevel
                        ) {
                            HStack {
                                Text(level.isCompleted ? "🔓 Level \(level.id)" : "🔒 Level \(level.id)")
                                Spacer()
                                if level.isCompleted {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                        }
                        .disabled(level.id > store.currentLevel)
                        .onTapGesture {
                            guard level.id <= store.currentLevel else { return }
                            store.currentLevel = level.id
                            selectedLevel = level.id
                        }
                    }
                }
                .navigationTitle("Map")
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                    Text("⚠️ لا توجد بيانات")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
              
            }
        }
    }

#Preview {
    MapView()
}
