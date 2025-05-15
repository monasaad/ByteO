//
//  ContentView.swift
//  ByteO
//
//  Created by Mona on 30/04/2025.
//

// MainMenuView.swift - Integrated with GameDataStore and SwiftData

import SwiftUI
import SwiftData
import Foundation


//struct MainMenuView: View {
//    @State private var showMap = false
//    @State private var showGame = false
//    @State private var isMuted: Bool = false
//    @State private var showScenario      = false
//    @State private var showInstructions  = false
//    @State private var navigateToGame    = false
//
//      @Environment(\.dismiss) var dismiss
//
//    @Environment(\.modelContext) private var context
//    @Query private var stores: [GameDataStore]
//
//   
//    // احصل على كيان واحد من GameDataStore أو أنشئه
//    private var GameData: GameDataStore {
//      if let existing = stores.first { return existing }
//      let player   = Player()
//      let settings = Settings()
//      let levels = QuestionBank
//        .shared.questionsByLevel.keys
//        .sorted()
//        .map { Level(id: $0) }
//      let gs = GameDataStore(
//        player: player,
//        settings: settings,
//        achievements: [],
//        levels: levels
//      )
//      context.insert(gs)
//      return gs
//    }
//    
//    
//    var body: some View {
//        NavigationStack  {
//            ZStack {
//                // 🔹 الخلفية
//                Image("menu_background")
//                    .resizable()
//                    .scaledToFill()
//                    .ignoresSafeArea()
//                
//                // 🔹 الأيقونات أعلى يسار الشاشة
//                VStack {
//                    
//                 HStack{
//                        // 💳 المحفظة (Wallet)
//                        NavigationLink(destination: achievementView(gameData: gameData)) {
//                            Image(systemName: "gearshape")
//                               // .resizable()
//                                .frame(width: 30, height: 20)
//                                .padding(10)
//                                .background(Color.black.opacity(0.3))
//                                .foregroundColor(.white)
//                                .clipShape(Circle())
//                            
//                        }
//                    }
////                         //Spacer()
//                          .padding(.bottom, 10)
//                          .padding(.leading, -400)
//                    HStack{
//                        // 💳 المحفظة (Wallet)
//                        NavigationLink(destination: achievementView(gameData: gameData)) {
//                            HStack {
//                                Image(systemName: "creditcard.fill")
//                                    .resizable()
//                                    .frame(width: 30, height: 20)
//                                    .padding(10)
//                                    .background(Color.black.opacity(0.3))
//                                    .foregroundColor(.white)
//                                    .clipShape(Circle())
//                                
//                //                                                   Text("\(gameData.player.coins)")
////                                   .foregroundColor(.white)
////                                   .font(.headline)
//                            }
//                        }
//                    }
//
//                             //Spacer()
//                              .padding(.bottom, 10)
//                              .padding(.leading, -400)
//                    HStack{
//                        // 🔊 إعدادات الصوت
//                        Button(action: {
//                            isMuted.toggle()
//                            gameData.settings.soundMuted = isMuted
//                        }) {
//                            Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
//                                .resizable()
//                                .frame(width: 30, height: 20)
//                                .padding(10)
//                                .background(Color.black.opacity(0.3))
//                                .foregroundColor(.white)
//                                .clipShape(Circle())
//                                .shadow(color: .gray, radius: 5, x: 0, y: 2)
//                        }
////                        .padding(.bottom, 10)
////                        .padding(.leading, -100)
//                    }
//                            
//                            .padding(.bottom, 170)
//                            .padding(.leading, -400)
//                }
// 
//                    // 🔹 صورة بياتو + الأزرار تحتها
//                    VStack(spacing: 10) {
//                        Spacer()
//                        
//                        Image("piato")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 300)
//                        
//                        HStack(spacing: 40) {
//                            // زر Map
//                            NavigationLink(destination: mapView(gameData: gameData)) {
//                                Text("Map")
//                                    .font(.headline)
//                                    .foregroundColor(.white)
//                                    .padding()
//                                    .background(.ultraThinMaterial)
//                                    .cornerRadius(10)
//                            }
//                            
//                            // زر Play
//                            NavigationLink(destination: DecryptionGameView(gameData: gameData)) {
//                                Text("Play")
//                                    .font(.headline)
//                                    .foregroundColor(.white)
//                                    .padding()
//                                    .background(.ultraThinMaterial)
//                                    .cornerRadius(10)
//                            }
//                            
//                            // زر Learn
//                            Button(action: {
//                                print("Learn tapped")
//                            }) {
//                                Text("Learn")
//                                    .font(.headline)
//                                    .foregroundColor(.white)
//                                    .padding()
//                                    .background(.ultraThinMaterial)
//                                    .cornerRadius(10)
//                            }
//                        }
//                        Spacer()
//                    }
//                }
//                .navigationBarBackButtonHidden(true)
//                .navigationBarHidden(true)
//            }
//        }
//    }
//
//#Preview {
//    MainMenuView()
//}

import SwiftUI
import SwiftData

struct MainMenuView: View {
  @Environment(\.modelContext) private var context
  @Query private var stores: [GameDataStore]

  // احصل على كيان واحد من GameDataStore أو أنشئه
  private var store: GameDataStore {
    if let existing = stores.first { return existing }
    let player   = Player()
    let settings = Settings()
    let levels = QuestionBank
      .shared.questionsByLevel.keys
      .sorted()
      .map { Level(id: $0) }
    let gs = GameDataStore(
      player: player,
      settings: settings,
      achievements: [],
      levels: levels
    )
    context.insert(gs)
    return gs
  }

  @State private var showScenario      = false
  @State private var showInstructions  = false
  @State private var navigateToGame    = false

  @Environment(\.dismiss) var dismiss

  var body: some View {
    NavigationStack {
      ZStack {
        Image("menu_background").resizable().scaledToFill().ignoresSafeArea()
        VStack(spacing: 20) {
          // أعلى اليسار: الصوت – المحفظة – الإنجازات
          HStack {
            // Sound toggle
            Button {
              store.settings.soundMuted.toggle()
            } label: {
              Image(systemName: store.settings.soundMuted
                      ? "speaker.slash.fill"
                      : "speaker.wave.2.fill")
            }
            .buttonStyle(.borderedProminent)

            // Wallet (Achievements)
            NavigationLink {
              achievementView(gameData: store)
            } label: {
              HStack {
                Image(systemName: "creditcard.fill")
                Text("\(store.player.coins)")
              }
            }

            Spacer()
          }
          .padding()

          Spacer()

          Image("piato").resizable().aspectRatio(contentMode: .fit).frame(width: 300)

          HStack(spacing: 40) {
            // Map
            NavigationLink {
              mapView()
//                InstructionsView()
            } label: {
              Text("Map")
            }

            // Play
            Button("Play") {
              if !showScenario {
                showScenario = true
              } else if !showInstructions {
                showInstructions = true
              } else {
                navigateToGame = true
              }
            }

            // Learn
            NavigationLink("Learn") {
                InstructionsView()
            }
          }
          .buttonStyle(.borderedProminent)

          Spacer()
        }

        // NavigationLinks الخفيّة
        NavigationLink(destination: ScenarioView(), isActive: $showScenario){
            EmptyView()
          }
        NavigationLink(destination: InstructionsView(), isActive: $showInstructions){ EmptyView() }
          
        NavigationLink(destination: DecryptionGameView(),isActive: $navigateToGame){ EmptyView() }
      }
      .navigationBarHidden(true)
    }
  }
}

#Preview {
  MainMenuView()
    .modelContainer(for: [ Player.self,
                           Settings.self,
                           Level.self,
                           Achievement.self,
                           GameDataStore.self ])
}

import SwiftUI
import SwiftData

struct ScenarioView: View {
  @Environment(\.modelContext) var context
  @Query private var stores: [GameDataStore]
  @State private var done = false

  private var store: GameDataStore { stores.first! }

  var body: some View {
    ZStack {
      Image("bg").resizable().ignoresSafeArea()
      VStack {
        Text("هنا قصة تمهيدية للاعب...")
          .multilineTextAlignment(.center)
          .padding()
        Button("ابدأ المهمة") {
          done = true
        }
      }
      .navigationDestination(isPresented: $done) {
        InstructionsView()
      }
    }
  }
}

import SwiftUI

struct InstructionsView: View {
  @Environment(\.modelContext) var context
  @Query private var stores: [GameDataStore]
  @State private var done = false

  private var store: GameDataStore { stores.first! }

  var body: some View {
    ZStack {
      Image("bg").resizable().ignoresSafeArea()
      ScrollView {
        Text("شرح طريقة اللعب:\n1. حرّك الحروف...\n2. اضغط Submit...")
          .padding()
        Button("موافق") {
          done = true
        }
      }
      .navigationDestination(isPresented: $done) {
        DecryptionGameView()
      }
    }
  }
}
