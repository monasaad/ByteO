//
//  MapScreen.swift
//  ByteO
//
//  Created by Mona on 30/04/2025.
//

import SwiftUI


struct MapScreen: View {
    var body: some View {
        ZStack {
            // Background color to distinguish the layout
            Color.black.edgesIgnoringSafeArea(.all)

            VStack {
                // Spacer to center the first VStack
                // Second VStack (Top-right aligned)
                HStack {
                    VStack{
                        Text("Top Right VStack")
                            .font(.title)
                            .foregroundColor(.white)
                        Text("This one is on the top right.")
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing) // Align this VStack to the top of the screen
                .background(Color.red.opacity(0.5)) // Just for visibility
                .cornerRadius(10)
                .padding() // Optional padding to give space from the edge
                
                // First VStack (Center of the screen)
                HStack {
                    Text("Centered VStack")
                        .font(.title)
                        .foregroundColor(.white)
                    Text("This one is centered.")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Make this VStack take full available space
                .background(Color.blue.opacity(0.5)) // Just for visibility
                .cornerRadius(10)

                // Spacer to push the second VStack to the right side
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure HStack takes full available space
        }
    }
}



#Preview {
    MapScreen()
}
