import SwiftUI
import SpriteKit

import SwiftUI
import AVKit
import SwiftUI
import AVKit

struct VideoContentView: View {
    @State private var player: AVPlayer?
    @Environment(GameDataStore.self) var gameData
    @Environment(\.dismiss) var dismiss
    @State private var navigateToTutorial = false
    var body: some View {
        
        NavigationStack {
            ZStack {
                // Video Player
                VideoPlayerView(player: $player)
                    .edgesIgnoringSafeArea(.all)
                
                // Continue Button
                VStack {
                    Spacer()
                    
                    Button(action: {
                            player?.pause()
                            gameData.playerProgress?.hasSeenIntro = true
                            gameData.save()
                            navigateToTutorial = true
                        
                         // Stop video playback
                        navigateToTutorial = true
                    }) {
                        Text("Continue")
                            .padding()
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.c4.opacity(0.6))
                                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.c4.opacity(0.3)))
                            )
                            .padding(.leading, 600)
                            .padding(.bottom, 40)
                    }
                }
                
                // Navigation Link
                NavigationLink("", destination: TutorialView(), isActive: $navigateToTutorial)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .onAppear {
                // Initialize player when view appears
                if player == nil {
                    player = AVPlayer(url: Bundle.main.url(forResource: "1", withExtension: "mov")!)
                    player?.play()
                }
            }
        }
        
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct VideoPlayerView: UIViewControllerRepresentable {
    @Binding var player: AVPlayer?
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false  // Hide native controls
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Update player if needed
        uiViewController.player = player
    }
}

struct VideoPlayerSpriteKitView_Previews: PreviewProvider {
    static var previews: some View {
        VideoContentView()
    }
}
