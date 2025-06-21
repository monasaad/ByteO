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
                    .font(.title.bold())
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
//                    Button(primaryButtonTitle) {
//                        primaryAction()
//                    }
//                    .buttonStyle(PrimaryButtonStyle(backgroundColor: track.color))
                }
            }
            .frame(width: 250, height: 200)  // <— control width & height here
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
