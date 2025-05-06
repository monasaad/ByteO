//
//  ContentView.swift
//  ByteO
//
//  Created by Mona on 30/04/2025.
//

import SwiftUI

struct MainScreen: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Background Image or Color (you can replace this with your actual background image)
                Image("bg").resizable().scaledToFit().edgesIgnoringSafeArea(.all)
//                Color.black.edgesIgnoringSafeArea(.all)

                VStack {
                    HStack {
                        VStack {
                            NavigationLink(destination: MapScreen()) {
                                Image(systemName: "gear")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                            }

                            NavigationLink(destination: MapScreen()) {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                            }
                        }
                    }.frame(maxWidth: .infinity, alignment: .trailing)

                    HStack {
                        VStack {
                            Text("ByteO")
                                .font(.system(size: 48, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(radius: 10)

                            Text("Crack the code, one byte at a time!")
                                .font(.system(size: 20, weight: .regular, design: .rounded))
                                .foregroundColor(.white)
                                .opacity(0.8)
                                .shadow(radius: 10)

                            NavigationLink(destination: PlayScreen()) {
                                Text("PLAY")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .bold, design: .rounded))  //
                                    .frame(width: 250, height: 60)  // Set button size
.background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]), startPoint: .top, endPoint: .bottom))  // Gradient background
.cornerRadius(10)
                            }.padding(.top, 20)

                            NavigationLink(destination: MapScreen()) {
                                Text("MAP")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))  // Font style
                                    .frame(width: 250, height: 60)  // Set button size
.background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]), startPoint: .top, endPoint: .bottom))  // Gradient background
                                    .foregroundColor(.white)  // Text color
                                    .cornerRadius(10)  // Rounded corners
//                                    .shadow(color: Color.blue.opacity(0.9), radius: 10, x: 5, y: 10)  //
                            }
                        }
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)

                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }

        }

    }
}

#Preview {
    MainScreen()
}
