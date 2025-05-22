//
//  gamestoryview.swift
//  ByteO
//
//  Created by atheer alshareef on 20/05/2025.
//
//import Foundation
//import SwiftUI
//
//struct IntroScenarioView: View {
//    @Environment(GameDataStore.self) var gameData
//    @Environment(\.dismiss) var dismiss
//    @State private var navigateToTutorial = false
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                Color.black.opacity(0.95).ignoresSafeArea()
//
//                VStack(spacing: 30) {
//
//
//                    Button(action: {
//                        gameData.playerProgress?.hasSeenIntro = true
//                        gameData.save()
//                        navigateToTutorial = true
//                    }) {
//                        Text("استمرار")
//                            .font(.headline)
//                            .padding()
//                            .frame(width: 200)
//                            .background(Color.green)
//                            .foregroundColor(.white)
//                            .cornerRadius(12)
//                    }
//
//                    NavigationLink("", destination: TutorialView(), isActive: $navigateToTutorial)
//                }
//                .padding()
//            }
//        }
//    }
//}

import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) var dismiss
    @State private var navigateToGame = false
    @State private var currentPage = 0

    let pages: [TutorialPage] = [
        TutorialPage(
            title: "How to play",
            content: "Symmetric Encryption\n\nIt’s a way we hide information, we turn normal words into strange symbols, and bring them back using the same key!\n\nOne key is used to encrypt and decrypt!"
        ),
        TutorialPage(
            title: "How to play",
            content: "Everything starts with a secret key\u{1F511} we use twice: \n\n1. To change the message’s form encryption\n\n2. To return it to its original form decryption\nand all using the same key!"
        ),
        TutorialPage(
            title: "How to play",
            content: "Simple Example:\nEncrypted word: “epps”\nKey: Shift each letter one step backward in the alphabet (i.e., –1)\nIt becomes: “door”\ne → d\np → o\np → o\ns → r"
        ),
        TutorialPage(
            title: "How to play",
            content: "It looks totally different!\nIt may look confusing at first, but anyone who knows the key\u{1F511} can easily turn ‘epps’ back into ‘door’.\n\n Ready to begin your mission?"
        )
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    ZStack(alignment: .topTrailing) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .frame(width: 500, height: 320)
                            .overlay(
                                VStack() {
                                    Text(pages[currentPage].title)
                                        .font(.title2.bold())
                                        .foregroundStyle(.white)
                                    Spacer()
                                    Text(pages[currentPage].content)
                                        .multilineTextAlignment(.leading)
                                        .font(.body)
                                    
                                    Spacer()
                                    if currentPage == 3{
                                        Button("Start") {
                                            navigateToGame = true
                                        }
                                        .font(.system(size: 20, weight: .semibold))
                                        .padding(.horizontal, 40)
                                        .padding(.vertical, 10)
                                        .foregroundColor(.white)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color.c4)
                                                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.c4.opacity(0.4)))
                                                .shadow(color: Color.c4, radius: 5, x: 2, y: 2))
                                    }else{
                                    HStack(spacing: 10) {
                                        ForEach(0..<pages.count, id: \ .self) { index in
                                            Circle()
                                                .fill(index == currentPage ? Color.orange : Color.white.opacity(0.5))
                                                .frame(width: 10, height: 10)
                                        }
                                    }}
                                }
                                    .padding()
                          )
                    }
                       
                    }
                Image("robot_zero")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(.top, -200)
                    .padding(.leading, 450)
                
                
//                    if currentPage < pages.count - 1 {
//                        Button(action: {
//                            withAnimation {
//                                currentPage += 1
//                            }
//                        }) {
//                            Image(systemName: "arrow.right.circle.fill")
//                                .font(.system(size: 36))
//                                .foregroundColor(.c3)
//                        }
//                        .padding(.top, 50)
//                        .padding(.leading, 450)
//                        
//                        
//                        
//                    } else {
//                        Button("Start") {
//                            navigateToGame = true
//                        }
//                        .font(.system(size: 20, weight: .semibold))
//                        .padding(.horizontal, 40)
//                        .padding(.vertical, 10)
//                        .foregroundColor(.white)
//                        .background(
//                            RoundedRectangle(cornerRadius: 20)
//                                .fill(Color.white.opacity(0.2))
//                                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.c4.opacity(0.4)))
//                                .shadow(color: Color.c4, radius: 10, x: 8, y: 8)
//                        )
//                      
//                         .padding(.top, 310)
//                         .padding(.leading, 500)
//                    }
                
                
                // Inside your VStack where the navigation controls are
              
                    // Back arrow (left side)
//                    if currentPage == 1 {
//                        Button(action: {
//                            withAnimation {
//                                currentPage -= 1
//                            }
//                        }) {
//                            Image(systemName: "arrow.left.circle.fill")
//                                .font(.system(size: 36))
//                                .foregroundColor(.c3)
//                        }
//                        .padding(.top, 50)
//                        .padding(.leading, -450)
//                    }
                    
                    // Forward arrow (right side) - your existing code
                    // 1 < 4-1 = 3
                    // 2<3
                    //3<3
                    // 4<3 -> btn
                // Navigation controls
                ZStack {
                    // Back Button - Left Side
                    HStack {
                        if currentPage > 0 {
                            Button(action: {
                                withAnimation {
                                    currentPage -= 1
                                }
                            }) {
                                Image(systemName: "arrow.left.circle.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(.c3)
                            }
                            .padding(.leading, 40)
                        }
                        Spacer()
                    }
                    
                    // Forward/Start Button - Right Side
                    HStack {
                        Spacer()
                        if currentPage < pages.count - 1 {
                            Button(action: {
                                withAnimation {
                                    currentPage += 1
                                }
                            }) {
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(.c3)
                            }
                        }
//                        else {
//                            Button("Start") {
//                                navigateToGame = true
//                            }
//                            .font(.system(size: 20, weight: .semibold))
//                            .padding(.horizontal, 40)
//                            .padding(.vertical, 10)
//                            .foregroundColor(.white)
//                            .background(
//                                RoundedRectangle(cornerRadius: 20)
//                                    .fill(Color.white.opacity(0.2))
//                                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.c4.opacity(0.4)))
//                                    .shadow(color: Color.c4, radius: 10, x: 8, y: 8)
//                            )
//                        }
                    }
                    .padding(.trailing, 40)
                }
                .padding(.top, 50)
                .frame(maxWidth: .infinity)
                .onChange(of: currentPage) { _, newValue in
                    // Ensure currentPage stays within valid bounds
                    currentPage = min(max(newValue, 0), pages.count - 1)
                }
                
//                    if currentPage < pages.count - 1 {
//                        Button(action: {
//                            withAnimation {
//                                currentPage += 1
//                            }
//                        }) {
//                            Image(systemName: "arrow.right.circle.fill")
//                                .font(.system(size: 36))
//                                .foregroundColor(.c3)
//                        }
//                        .padding(.top, 50)
//                        .padding(.leading, 450)
//                        
//                        // 1
//                        //2
//                        //3
//                        //4
//                        
//                        if currentPage > 0 {
//                            
//                            Button(action: {
//                                withAnimation {
//                                    currentPage -= 1
//                                }
//                            }) {
//                                Image(systemName: "arrow.left.circle.fill")
//                                    .font(.system(size: 36))
//                                    .foregroundColor(.c3)
//                            }
//                            .padding(.top, 50)
//                            .padding(.leading, -500)
//                        }
//                        
//                    } else {
//                        Button("Start") {
//                            navigateToGame = true
//                        }
//                        .font(.system(size: 20, weight: .semibold))
//                        .padding(.horizontal, 40)
//                        .padding(.vertical, 10)
//                        .foregroundColor(.white)
//                        .background(
//                            RoundedRectangle(cornerRadius: 20)
//                                .fill(Color.white.opacity(0.2))
//                                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.c4.opacity(0.4)))
//                                .shadow(color: Color.c4, radius: 10, x: 8, y: 8)
//                        )
//                      
//                         .padding(.top, 310)
//                         .padding(.leading, 500)
//                    }
                
                  
                    Spacer()

                NavigationLink("", destination: GameView(), isActive: $navigateToGame)
                
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
}

struct TutorialPage: Hashable {
    var title: String
    var content: String
}

#Preview {
    TutorialView()
        .environment(GameDataStore.shared)
}


//
//
//struct TutorialView: View {
//    @Environment(\.dismiss) var dismiss
//    @State private var navigateToGame = false
//
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 20) {
//                Text(" ")
//                    .font(.largeTitle.bold())
//
//                Text(" ")
//                .multilineTextAlignment(.leading)
//                .padding()
//
//                Button(" ") {
//                    navigateToGame = true
//                }
//                .font(.headline)
//                .padding()
//                .frame(width: 200)
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(12)
//
//                NavigationLink("", destination: GameView(), isActive: $navigateToGame)
//            }
//            .padding()
//        }
//    }
//}
