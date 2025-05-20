import SwiftUI
import SpriteKit
import AVKit

struct VideoContentView: View {
    @State private var player: AVPlayer?
    @Environment(GameDataStore.self) var gameData
    @Environment(\.dismiss) var dismiss
    @State private var navigateToTutorial = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fullscreen Video Player
                VideoPlayerView(player: $player)
                    .edgesIgnoringSafeArea(.all)
                
                // Continue Button Layout
                VStack {
                    Spacer()
                    
                    // Continue Button
                    Button(action: handleContinue) {
                        Text("Continue")
                            .padding()
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.c4.opacity(0.6))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.c4.opacity(0.3))))
                    }
                    .padding(.bottom, 5)
                }
                .frame(maxWidth: .infinity)
                
                // Navigation Link
                NavigationLink("",
                    destination: TutorialView(),
                    isActive: $navigateToTutorial
                )
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .onAppear(perform: setupPlayer)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func handleContinue() {
        player?.pause()
        gameData.playerProgress?.hasSeenIntro = true
        gameData.save()
        navigateToTutorial = true
    }
    
    private func setupPlayer() {
        guard player == nil else { return }
        player = AVPlayer(url: Bundle.main.url(forResource: "11", withExtension: "mov")!)
        player?.play()
    }
}

struct VideoPlayerView: UIViewControllerRepresentable {
    @Binding var player: AVPlayer?
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
    }
}

struct VideoPlayerSpriteKitView_Previews: PreviewProvider {
    static var previews: some View {
        VideoContentView()
            .environment(GameDataStore())
    }
}
