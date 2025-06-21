//
//   CustomButtonStyles.swift
//  ByteO
//
//  Created by Shatha Almukhaild on 25/12/1446 AH.
//

import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .font(.system(size: 20, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(color.opacity(0.7))
                    )
                  //  .shadow(color: color, radius: 10, x: 2, y: 0)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    var backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .font(.system(size: 20, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}


struct ButtonStyles_Previews: View {
    var body: some View {
        VStack(spacing: 20) {
            Button("Secondary Button") {}
                .buttonStyle(SecondaryButtonStyle(color: .orange))
            
            Button("Primary Button") {}
                .buttonStyle(PrimaryButtonStyle(backgroundColor: .orange))
        }
        .padding()
        .background(Color.black.opacity(0.9))
        .previewLayout(.sizeThatFits)
    }
}

#Preview {
    ButtonStyles_Previews()
}
