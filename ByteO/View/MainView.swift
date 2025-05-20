import SwiftUI
import AVFoundation

struct MainMenuView: View {
    @Environment(GameDataStore.self) var gameData
    @State private var navigateToIntro = false
    @State private var navigateToGame = false
    @State private var navigateToMap = false
    @State private var navigateToSettings = false
    @State private var navigateToAchievements = false
    @State private var showCoinStore = false
    // Audio state
      @AppStorage("isMuted") private var isMuted: Bool = false
      @State private var playerAudio: AVAudioPlayer?
    // MARK: - Sound control
    private func toggleSound() {
        isMuted.toggle()
        if isMuted {
            playerAudio?.pause()
        } else {
            playerAudio?.play()
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // 🔵 الخلفية (تقدر تحط صورة أو لون خاص)
                Image("bg2")
                    .resizable()
                    //.scaledToFit()
                    .edgesIgnoringSafeArea(.all)
                
              
                HStack{
                     
                    VStack{
                        // 🏆 الإنجازات
                        Button(action: {
                            navigateToAchievements = true
                        }) {
                            Image(systemName: "trophy")
                                .frame(width: 40, height: 20)
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(color: .c4.opacity(0.7), radius: 8, x: 0, y: 5)
                            
                        }
                        
//                        // 🔇 زر الصوت
//                        Button(action: toggleSound) {
//                            Image(systemName: settings?.soundMuted == true ? "speaker.slash.fill" : "speaker.wave.2.fill")
//                                .scaledToFit()
//                                .frame(width: 40, height: 20)
//                                .padding(10)
//                                .background(.ultraThinMaterial)
//                                .foregroundColor(.white)
//                                .clipShape(Circle())
//                                .shadow(color: .c4.opacity(0.7), radius: 8, x: 0, y: 5)
//                        }
                        // Sound toggle
                                    Button(action: toggleSound) {
                                        Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                                            .scaledToFit()
                                            .frame(width: 40, height: 20)
                                            .padding(10)
                                            .background(.ultraThinMaterial)
                                            .foregroundColor(.white)
                                            .clipShape(Circle())
                                            .shadow(color: .c4.opacity(0.7), radius: 8, x: 0, y: 5)
                                    }

                 
                    
                        // 💰 عدد الكوينز
                        Button(action: {
                            showCoinStore = true
                        }) {
                            HStack {
                                Image(systemName: "wallet.bifold.fill")
                                    .frame(width: 40, height: 20)
                                    .padding(10)
                                    .background(.ultraThinMaterial)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                                    .shadow(color: .c4.opacity(0.7), radius: 8, x: 0, y: 5)
//                                Text("\(gameData.playerProgress?.coins ?? 0)")
                            }
                        }
                        Spacer()
                  
                        
                    }
                    Spacer()
                }.padding(.top,20)
               
            
                VStack() {
          
//                    // 🧠 عنوان اللعبة
//                    Text("لعبة تشفير سيزر")
//                        .font(.largeTitle.bold())
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                
                    // 🟢 زر بدء اللعب
                    Button(action: {
                        if gameData.playerProgress?.hasSeenIntro == false {
                            navigateToIntro = true
                        } else {
                            navigateToGame = true
                        }
                    }) {
                        Text("Play")
                            .font(.system(size: 25, weight: .bold))
                       
                    }
                        .foregroundColor(.white)
                        .frame(width: 95, height: 40) // ← الطول والعرض
                        .background(Color.c4)      // ← لون الخلفية
                        .cornerRadius(30)              // ← الزوايا الدائرية
                        .shadow(color: .c4.opacity(0.4), radius: 8, x: 0, y: 5)

                    // 🗺️ زر الخريطة
                    Button(action: {
                        navigateToMap = true
                    }) {
                        Text("Map")
                            .font(.system(size: 25, weight: .bold))

                         
                    }
                    .foregroundColor(.white)
                    .frame(width: 95, height: 40)
                    .background(.ultraThinMaterial)
                    .cornerRadius(30)
                    .shadow(color: .c4.opacity(0.4), radius: 8, x: 0, y: 5)

                    Spacer()

                    // ✅ التنقلات المخفية
                    NavigationLink("", destination: VideoContentView(), isActive: $navigateToIntro)
                    NavigationLink("", destination: GameView(), isActive: $navigateToGame)
                    NavigationLink("", destination: MapView(), isActive: $navigateToMap)
                  
                    .onAppear {
                      // 1️⃣ configure the session
                      do {
                        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                        try AVAudioSession.sharedInstance().setActive(true, options: [])
                      } catch {
                        print("⚠️ audio session error:", error)
                      }

                      // 2️⃣ load & prep the player
                      if let url = Bundle.main.url(forResource: "CipherintheMetro", withExtension: "m4a") {
                        playerAudio = try? AVAudioPlayer(contentsOf: url)
                        playerAudio?.numberOfLoops = -1
                        playerAudio?.prepareToPlay()
                        if !isMuted {
                          playerAudio?.play()
                        }
                      }
                    }
                    .onDisappear {
                         playerAudio?.pause() // أو .stop() لو حاب توقفه نهائياً
                     }

                }
                .padding(.top,100)
                .padding(.leading,100)
                .animation(.spring(), value: showCoinStore)
                // ── Overlay pop-up ──
                if showCoinStore {
                    CoinStoreView(isPresented: $showCoinStore)
                        .frame(width: 340, height: 420)        // ← fixed size
                        .background(.ultraThinMaterial)
                        //.zIndex(1)
                }

             
//                // ⛳ روابط الإعدادات والإنجازات
//                NavigationLink("", destination: SettingsView(), isActive: $navigateToSettings)
                NavigationLink("", destination: AchievementsView(), isActive: $navigateToAchievements)
            }
        }.navigationBarBackButtonHidden(true)
        
        
    }
    

}



#Preview {
    MainMenuView().environment(GameDataStore.shared)
}
