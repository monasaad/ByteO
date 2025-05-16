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

    var player: Player? {
        gameData.first?.player
    }

    var settings: Settings? {
        gameData.first?.settings
    }

    var body: some View {
        NavigationView {
            ZStack {
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack(alignment: .top) {
                        VStack() {
                            // ⚙️ الإعدادات / صفحة الإنجازات
                            Button(action: {
                                showAchievements = true
                            }) {
                                Image(systemName: "gearshape")
                                // .resizable()
                                    .frame(width: 40, height: 20)
                                    .padding(10)
                                    .background(.ultraThinMaterial)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                            .sheet(isPresented: $showAchievements) {
                            }
                            .padding(.bottom, 1)
                            // 🔇 زر الصوت
                            Button(action: toggleSound) {
                                Image(systemName: settings?.soundMuted == true ? "speaker.slash.fill" : "speaker.wave.2.fill")
                                    .frame(width: 40, height: 20)
                                    .padding(10)
                                    .background(.ultraThinMaterial)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                            
                            // 👜 الكوينز
                            HStack(spacing: 6) {
                                Image(systemName: "creditcard.fill")
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
                            // .clipShape(Circle())
                        }
                        .padding(.leading, -20)
                        .padding(.bottom, -140)
                        Spacer()
                    }
                    
                    
                    
                    VStack(){
                     Spacer()
                    // 🐱 صورة القطة
                    Image("cat_avatar")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300)

                    // أزرار اللعب والخريطة
                        VStack() {
                            
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
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(.c3)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                          //  .frame(width: 900, height: 50)
                            Button("Map") {
                                checkForReset()
                                navigateToMap = true
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                        }
                }
            }
                // الروابط
                NavigationLink(destination: MapView(), isActive: $navigateToMap) { EmptyView() }.hidden()
                NavigationLink(destination: IntroView(), isActive: $navigateToIntro) { EmptyView() }.hidden()
            }
            .onAppear(perform: prepareSound)
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
        guard let url = Bundle.main.url(forResource: "menu_music", withExtension: "mp3") else { return }
        do {
            playerAudio = try AVAudioPlayer(contentsOf: url)
            playerAudio?.numberOfLoops = -1
            if settings?.soundMuted == false {
                playerAudio?.play()
            }
        } catch {
            print("⚠️ فشل تشغيل الصوت: \(error.localizedDescription)")
        }
    }

    private func toggleSound() {
        guard let settings = settings else { return }
        settings.soundMuted.toggle()
        if settings.soundMuted {
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
            Image("bg")
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
        .background(
            NavigationLink(destination: DecryptionGameView(levelID: 1), isActive: $navigateToGame) {
                EmptyView()
            }.hidden()
        )
    }
}


