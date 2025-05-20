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
            content: "Symmetric Encryption\nIt’s a way we hide information...\n We turn normal words into strange symbols,\n and bring them back using the same key!\n\n One Key \n is used to encrypt and decrypt!"
        ),
        TutorialPage(
            title: "How to play",
            content: "Everything starts with a \u{1F511} secret key we use twice: 1. To change the message’s form encryption\n2. To return it to its original form decryption\n and all using the same key!"
        ),
        TutorialPage(
            title: "How to play",
            content: "Simple Example:\n Original word: \"door\"\nKey: Shift each letter one step forward in the alphabet (i.e., +1)\nIt becomes: \"epps\"\n• d -> e\n• o -> p\n• o -> p\n• r -> s"
        ),
        TutorialPage(
            title: "How to play",
            content: "Simple Example:\n It looks totally different!\nBut anyone who knows the key (+1) can easily turn it back\ninto \"door\".\n\n Ready to begin your mission?"
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
                            .frame(width: 350, height: 320)
                            .overlay(
              VStack(alignment: .leading, spacing: 16) {
                                    Text(pages[currentPage].title)
                                        .font(.title2.bold())
                                        .foregroundStyle(.white)
                                        .padding(.leading, 90)

                                    Text(pages[currentPage].content)
                                        .multilineTextAlignment(.leading)
                                        .font(.body)

                                    Spacer()

                                    HStack(spacing: 15) {
                                        ForEach(0..<pages.count, id: \ .self) { index in
                                            Circle()
                                                .fill(index == currentPage ? Color.orange : Color.gray.opacity(0.4))
                                                .frame(width: 10, height: 10)
                                        }
                                    }
                                }
                                    .padding()
                          )
                    }
                       
                    }
                Image("robot_zero")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(.top, -190)
                    .padding(.leading, 400)
                
                
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
                        .padding(.top, 50)
                        .padding(.leading, 450)
                    } else {
                        Button("Start") {
                            navigateToGame = true
                        }
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.horizontal, 40)
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.2))
                                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.c4.opacity(0.4)))
                                .shadow(color: Color.c4, radius: 10, x: 8, y: 8)
                        )
                      
                         .padding(.top, 310)
                         .padding(.leading, 500)
                    }
                  
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
