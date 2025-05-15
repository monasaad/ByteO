// achievementView.swift - Updated for SwiftData Integration

import SwiftUI
import SwiftData

struct achievementView: View {
    var gameData: GameDataStore

    var body: some View {
        NavigationView {
            VStack {
                Text("Achievements")
                    .font(.largeTitle)
                    .padding()

                List(gameData.achievements, id: \.id) { achievement in
                    HStack {
                        if achievement.isUnlocked {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Achievements")
        }
    }
}


//#Preview {
//    achievementView(gameData: GameDataStore())
//}
