//
//  ByteOApp.swift
//  ByteO
//
//  Created by Mona on 30/04/2025.
//

import SwiftUI
import SwiftData

@main
struct ByteOApp: App {
  // نحدد كل الـ @Model types
  var body: some Scene {
    WindowGroup {
      MainMenuView()
        .modelContainer(
          for: [
            Player.self,
            Settings.self,
            Level.self,
            Achievement.self,
            GameDataStore.self
          ]
        )
    }
  }
}
