//
//  ByteOApp.swift
//  ByteO
//
//  Created by Mona on 30/04/2025.
//

import SwiftUI

@main
struct ByteOApp: App {
    @AppStorage("isMuted") private var isMuted = true  
    var body: some Scene {
        WindowGroup {
            MainMenuView()
                .environment(GameDataStore.shared)
                .onAppear {
                    SoundManager.shared.startBackgroundMusic(isMuted: isMuted)
                }
        }
    }
}
