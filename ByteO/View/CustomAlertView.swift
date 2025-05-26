import SwiftUI

struct CustomAlertView: View {
    let title: String
    let message: String
    let primaryButtonTitle: String
    let secondaryButtonTitle: String
    let primaryAction: () -> Void
    let secondaryAction: () -> Void
    @Environment(GameDataStore.self) var gameData


    var body: some View {
        let progress = gameData.playerProgress
        let tracks = LevelData.allTracks
        let rawTrackIndex = progress?.currentTrackIndex ?? 0

        let trackIndex = min(max(0, rawTrackIndex), tracks.count - 1)
        let track = tracks[trackIndex]
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.9))
                
                HStack(spacing: 20) {
//                    Button(secondaryButtonTitle) {
//                        secondaryAction()
//                    }
//                    .buttonStyle(AlertButtonStyle(backgroundColor: .gray))
//                    
                    Button(primaryButtonTitle) {
                        primaryAction()
                    }
                    .buttonStyle(AlertButtonStyle(backgroundColor: .c4))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(track.color).opacity(0.8), lineWidth: 1.8))
                    .shadow(color: track.color.opacity(0.5), radius: 8, x: 0, y: 5)
            )
            .padding()
        }
    }
}

struct AlertButtonStyle: ButtonStyle {
    var backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
#Preview{
    CustomAlertView(
        title: "Hint",
        message: "\("Hint")",

        // if hints is used, change watch ad to Watch Ad
        primaryButtonTitle: "Got it!",
        secondaryButtonTitle: "Cancel",

        primaryAction: {
            // Handle ad watching logic
            print("Start playing ad...")
            
        },
        secondaryAction: {
            print("Start playing ad...")
        }
    )
}
