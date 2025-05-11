//
//  ContentView.swift
//  ByteO
//
//  Created by Mona on 30/04/2025.
//

import SwiftUI

struct MainMenuView: View {
    @AppStorage("currentLevel") var currentLevel: Int = 0
    @State private var showMap = false
    @State private var showGame = false

    var body: some View {
        NavigationStack  {
            ZStack {
                // 🔹 الخلفية
                Image("menu_background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                // 🔹 الأيقونات أعلى يسار الشاشة
                VStack {
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "creditcard.fill")
                                .resizable()
                                .frame(width: 30, height: 20)
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }

                        Button(action: {}) {
                            Image(systemName: "speaker.wave.2.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }

                        Spacer()
                    }
                    .padding([.leading, .top], 20)

                    Spacer()
                }

                // 🔹 صورة بياتو + الأزرار تحتها
                VStack(spacing: 10) { // 🔽 قللنا المسافة من 30 إلى 10
                    Spacer()

                    Image("piato")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300)

                    HStack(spacing: 40) {
                        // زر Map
                        Button(action: { showMap = true }) {
                            Text("Map")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                                
                        }

                        // زر Play
                        Button(action: {
                            if currentLevel == 0 {
                                showMap = true
                            } else {
                                showGame = true
                            }
                        }) {
                            Text("Play")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                                
                        }

                        // زر Learn
                        Button(action: {
                            // لاحقًا
                        }) {
                            Text("Learn")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                                
                        }
                    }

                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showMap) {
                MapView()
            }
            
           /* .navigationDestination(isPresented: $showGame) {
                GameLevelView(level: currentLevel)
            }*/
        }
    }
}

#Preview {
    MainMenuView()
}
