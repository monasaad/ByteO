import SwiftUI

struct CustomAlertView: View {
    let title: String
    let message: String
    let primaryButtonTitle: String
    let secondaryButtonTitle: String
    let primaryAction: () -> Void
    let secondaryAction: () -> Void
    
    var body: some View {
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
                    Button(secondaryButtonTitle) {
                        secondaryAction()
                    }
                    .buttonStyle(AlertButtonStyle(backgroundColor: .gray))
                    
                    Button(primaryButtonTitle) {
                        primaryAction()
                    }
                    .buttonStyle(AlertButtonStyle(backgroundColor: .c2))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.c2.opacity(0.8), lineWidth: 1.8))
                    .shadow(color: .c2.opacity(0.5), radius: 8, x: 0, y: 5)
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
