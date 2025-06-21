//
//  SoundManager.swift
//  ByteO
//
//  Created by Shatha Almukhaild on 25/12/1446 AH.
//
import SwiftUI
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var player: AVAudioPlayer?
    
    func startBackgroundMusic(isMuted: Bool) {
        print("🔊 Starting background music: isMuted = \(isMuted)")
        
        if player == nil {
            if let url = Bundle.main.url(forResource: "CipherintheMetro", withExtension: "m4a") {
                do {
                    player = try AVAudioPlayer(contentsOf: url)
                    player?.numberOfLoops = -1
                    player?.prepareToPlay()
                } catch {
                    print("❌ Failed to initialize player:", error)
                }
            } else {
                print("❌ Audio file not found!")
            }
        }
        
        if !isMuted, !(player?.isPlaying ?? false) {
            player?.play()
        }
    }
    
    func pause() {
        print("🔇 Pausing")
        player?.pause()
    }
    
    func resume() {
        print("▶️ Resuming")
        player?.play()
    }
    
    func stop() {
        print("⛔ Stopping")
        player?.stop()
        player = nil
    }
}
