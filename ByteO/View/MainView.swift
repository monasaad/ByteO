//
//  mainview.swift
//  testgame
//
//  Created by atheer alshareef on 15/05/2025.
//
import SwiftUI
import SwiftData
import AVFoundation
struct MainMenuView: View {
    @Environment(\.modelContext) private var context
    @Query var gameData: [GameDataStore]

    @State private var navigateToMap = false
    @State private var navigateToIntro = false
    @State private var showAchievements = false
    @State private var playerAudio: AVAudioPlayer?
    @State private var isMuted: Bool = false
    
    var player: Player? {
        gameData.first?.player
    }

    var settings: Settings? {
        gameData.first?.settings
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg2")
                    .resizable()
                    //.scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    //  VStack(alignment: .leading, spacing: 12) {
                    // ⚙️ الإعدادات / صفحة الإنجازات
                    Button(action: {
                        showAchievements = true
                    }) {
                        Image(systemName: "trophy")
                            .frame(width: 40, height: 20)
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(color: .c4.opacity(0.7), radius: 8, x: 0, y: 5)
                        
                    }
                    .sheet(isPresented: $showAchievements) {
                    }
                    
                    // 🔇 زر الصوت
                    Button(action: toggleSound) {
                        Image(systemName: settings?.soundMuted == true ? "speaker.slash.fill" : "speaker.wave.2.fill")
                            .scaledToFit()
                            .frame(width: 40, height: 20)
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(color: .c4.opacity(0.7), radius: 8, x: 0, y: 5)
                    }
                    
                    // 👜 الكوينز
                    HStack(spacing: 1) {
                        Image(systemName: "wallet.pass.fill")
                            .frame(width: 40, height: 20)
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                        
                        Text("\(player?.coins ?? 0)")
                            .foregroundColor(.white)
                    }
                    .frame(width: 40, height: 20)
                    .padding(10)
                    //.background(.ultraThinMaterial)
                    .foregroundColor(.white)
                    //.clipShape(Circle())
                    .shadow(color: .c4.opacity(0.7), radius: 8, x: 0, y: 5)
                }
                .padding(.leading, -400)
                .padding(.bottom, 210)
                
                 VStack{
                     
                    // أزرار اللعب والخريطة
                     Button("Play") {
                         if gameData.isEmpty {
                             let levels = (1...10).map { Level(id: $0) }
                             let player = Player()
                             let settings = Settings()
                             let store = GameDataStore(player: player, settings: settings, levels: levels)

                             context.insert(store)
                             try? context.save()

                             DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                 navigateToIntro = true
                             }
                         } else if let seen = gameData.first?.settings.hasSeenIntro, !seen {
                             gameData.first?.settings.hasSeenIntro = true
                             try? context.save()
                             navigateToIntro = true
                         } else {
                             checkForReset()
                             navigateToMap = true
                         }
                     }
                     .font(.system(size: 25, weight: .bold))
                     .foregroundColor(.white)
                     .frame(width: 95, height: 40) // ← الطول والعرض
                     .background(Color.c4)      // ← لون الخلفية
                     .cornerRadius(30)              // ← الزوايا الدائرية
                     .shadow(color: .c4.opacity(0.4), radius: 8, x: 0, y: 5)
                     
                  
                        Button("Map") {
                            checkForReset()
                            navigateToMap = true
                        }
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 95, height: 40)
                        .background(.ultraThinMaterial)
                        .cornerRadius(30)
                        .shadow(color: .c4.opacity(0.4), radius: 8, x: 0, y: 5)
                    
                     }
                        .padding(.leading, 100)
                        .padding(.top, 250)
                
                // الروابط
                .navigationDestination(isPresented: $navigateToMap) {
                    MapView() }
                .navigationDestination(isPresented: $navigateToIntro) {
                    IntroView() }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)

            .onAppear {
                isMuted = settings?.soundMuted ?? false
                prepareSound()
            }
        }
    }

    private func checkForReset() {
        guard let player = gameData.first?.player else { return }
        if player.attempts <= 0, let resetTime = player.lastAttemptsReset {
            let now = Date()
            let nextReset = resetTime.addingTimeInterval(60 * 60 * 24)
            if now >= nextReset {
                player.attempts = 3
                player.lastAttemptsReset = nil
                try? context.save()
            }
        }
    }
    private func prepareSound() {
          guard let url = Bundle.main.url(forResource: "CipherintheMetro", withExtension: "mp3") else {
              print("⚠️ الملف غير موجود!")
              return
          }

          do {
              playerAudio = try AVAudioPlayer(contentsOf: url)
              playerAudio?.numberOfLoops = -1
              if !isMuted {
                  playerAudio?.play()
              }
          } catch {
              print("⚠️ فشل تشغيل الصوت: \(error.localizedDescription)")
          }
      }
    
    private func toggleSound() {
        guard let settings = settings else { return }
        isMuted.toggle()
        settings.soundMuted = isMuted
        
        if isMuted {
            playerAudio?.pause()
        } else {
            playerAudio?.play()
        }
        
        try? context.save()
    }
}

#Preview {
    MainMenuView()
}


//
struct IntroView: View {
    @State private var navigateToGame = false

    var body: some View {
        ZStack {
            Image("bg2")
                .resizable()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                Text("مرحبا بك في عالم التشفير!")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                Text("في هذا العالم الغامض، ستتلقى رسائل مشفّرة عليك فكها باستخدام شيفرة القيصر...")
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(.white.opacity(0.9))

                Text("كل مستوى يحتوي على مهمة سرية، ومفتاح لحل التشفير. استخدم مهاراتك، لكن احذر — لديك محاولات محدودة!")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundColor(.white.opacity(0.8))

                Button("start"){
                    navigateToGame = true
                  
                }
                .padding()
                .background(Color.c3)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigateToGame){
        DecryptionGameView(levelID: 1)}
//        .background(
//            NavigationLink(destination: DecryptionGameView(levelID: 1), isActive: $navigateToGame) {
//                EmptyView()
//            }.hidden()
//        )
    }
}

