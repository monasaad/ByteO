import SwiftUI


// MARK: - Combined Progress Box (using LevelTrack)
struct CombinedProgressBox: View {
    @Environment(GameDataStore.self) var gameData
    let tracks: [LevelTrack]
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Byto Progress")
                .font(.headline)

            // اجمع كل المستويات مع مسارها
            let allLevels: [(LevelTrack, StaticLevel)] = tracks.flatMap { track in
                track.levels.map { (track, $0) }
            }
            let total = allLevels.count
            let completed = allLevels.filter { track, level in
                let key = gameData.levelKey(trackName: track.name, levelNumber: level.number)
                return gameData.playerProgress?.completedLevels.contains(key) ?? false
            }.count
            let progress = total > 0 ? Double(completed) / Double(total) : 0

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 8)
                    Capsule()
                        .fill(Color.green)
                        .frame(width: geo.size.width * progress, height: 8)
                    HStack {
                        Circle().fill(Color.green).frame(width: 20, height: 20)
                        Spacer()
                        Circle().fill(Color.gray).frame(width: 20, height: 20)
                    }
                    Image("ByteOWalking")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .offset(x: CGFloat(progress) * (geo.size.width - 24))
                        .animation(.linear(duration: 0.5), value: progress)
                }
            }
            .frame(height: 24)

            Text("\(Int(progress * 100))% completed")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(8)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}
import SwiftUI

// MARK: - Progress Map View (Horizontal Metro Style)
struct MapView: View {
    @Environment(GameDataStore.self) var gameData
    @Environment(\.dismiss) private var dismiss
    @State private var selectedID: UUID? = nil
    @State private var navigate = false

    // المسارات الثابتة من LevelData
    private var tracks: [LevelTrack] { LevelData.allTracks }
    // جميع المستويات مرفقة ببيانات المسار والفهرس
    private var allMeta: [(trackIndex: Int, levelIndex: Int, level: StaticLevel, track: LevelTrack)] {
        tracks.enumerated().flatMap { (tIdx, track) in
            track.levels.enumerated().map { (lIdx, level) in
                (tIdx, lIdx, level, track)
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
              
                VStack{
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.backward.circle.fill")
                                .font(.title)
                                .foregroundColor(.c3)
                                .frame(width: 50, height: 50)
                                .background(Color.white.opacity(0.4))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    Spacer()
                }.padding(.top,10)
            
         
                VStack(alignment: .leading, spacing: 16) {
                    
                    // .padding()
                    // شريط التقدم الكلي
                    CombinedProgressBox(tracks: tracks)
                        .frame(width: 735,height: 150)
                    //.padding(.horizontal, )
                        .padding(.top, 60)
                    
                    // خريطة المستويات الأفقية
                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack(spacing: 12) {
                            // عناوين الخطوط
                            HStack(spacing: 0) {
                                ForEach(allMeta.indices, id: \.self) { idx in
                                    let lineName = allMeta[idx].track.name
                                    if idx == 0 || allMeta[idx - 1].track.name != lineName {
                                        Text(lineName)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    } else {
                                        Spacer().frame(width: 74)
                                    }
                                }
                            }
                            
                            // الصف المتصل للمستويات
                            HStack(spacing: 0) {
                                ForEach(allMeta, id: \.level.id) { meta in
                                    let (tIdx, lIdx, level, track) = meta
                                    HStack(spacing: 0) {
                                        if !(tIdx == 0 && lIdx == 0) {
                                            Rectangle()
                                                .fill(track.color)
                                                .frame(width: 40, height: 4)
                                        }
                                        
                                        // حساب حالة المستوى
                                        // حساب حالة المكتمل أولاً
                                        let key = gameData.levelKey(trackName: track.name, levelNumber: level.number)
                                        let completed = gameData.playerProgress?.completedLevels.contains(key) ?? false
                                        
                                        // إذا أنهيته يبقى مفتوح، وإلا طبق المنطق الاعتيادي
                                        let unlocked: Bool = {
                                            if completed { return true }
                                            let ti = gameData.playerProgress?.currentTrackIndex ?? 0
                                            let li = gameData.playerProgress?.currentLevelIndex ?? 0
                                            if tIdx > ti { return false }
                                            if tIdx == ti && lIdx > li { return false }
                                            return true
                                        }()
                                        
                                        // تحديد المستوى الحالي
                                        let isCurrent: Bool = {
                                            let ti = gameData.playerProgress?.currentTrackIndex ?? 0
                                            let li = gameData.playerProgress?.currentLevelIndex ?? 0
                                            return tIdx == ti && lIdx == li
                                        }()
                                        // تكبير الدائرة إذا كان محدد أو المستوى الحالي
                                        let isHighlighted = isCurrent || selectedID == level.id
                                        
                                        ZStack {
                                            Circle()
                                                .fill(track.color)
                                                .frame(width: isHighlighted ? 40 : 30,
                                                       height: isHighlighted ? 40 : 30)
                                                .shadow(color: isHighlighted ? track.color.opacity(0.8) : .clear,
                                                        radius: isHighlighted ? 10 : 0)
                                                .scaleEffect(isHighlighted ? 1.2 : 1.0)
                                                .opacity(unlocked ? 1.0 : 0.5)
                                                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isHighlighted)
                                            
                                            Image(systemName: unlocked ? "lock.open" : "lock")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 14, height: 14)
                                                .foregroundColor(.white)
                                        }
                                        .onTapGesture {
                                            guard unlocked else { return }
                                            selectedID = level.id
                                            // تحديث الحالة في الموديل
                                            gameData.playerProgress?.currentTrackIndex = tIdx
                                            gameData.playerProgress?.currentLevelIndex = lIdx
                                            gameData.save()
                                            navigate = true
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                    }
                    //.padding(.leading, 15)
                    .frame(maxWidth: .infinity) // <-- هنا: لضمان العرض الكامل
                    
                    Spacer()
                }
            }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $navigate) {
                GameView()
            }
        }
    }





struct SettingsView: View {
    var body: some View {
        Text("الإعدادات...")
    }
}

struct AchievementsView: View {
    var body: some View {
        Text("الإنجازات...")
    }
}

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
//                    Text("📜 القصة")
//                        .font(.largeTitle.bold())
//                        .foregroundColor(.white)
//
//                    Text("""
//                    في عالم مليء بالأسرار والرسائل المشفّرة، أنت الجاسوس المختار لحلّ ألغاز قد تغيّر مجرى التاريخ.
//                    
//                    ستواجه تحديات من عصور مختلفة، وسلاحك الوحيد هو قدرتك على فهم الشفرات. هل أنت مستعد؟
//                    """)
//                    .font(.body)
//                    .multilineTextAlignment(.center)
//                    .foregroundColor(.white)
//                    .padding()
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
//
//


struct CoinStoreView: View {
  @Environment(GameDataStore.self) var gameData
  @Binding var isPresented: Bool   // parent controls this

  var body: some View {
      Spacer()
      Spacer()
    ZStack {
      // Dimmed background


    // VStack {
        Spacer()
        
        VStack(spacing: 0) {
          // Close button
           // Spacer()
            Spacer()
          HStack {
           
            Button {
              isPresented = false
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 15, height: 15) // حجم الأيقونة "xmark" أصغر
                    .foregroundColor(.white) // اللون الأبيض للأيقونة
                    .background(
                        Circle() // استخدام دائرة خلفية
                            .fill(Color.orange.opacity(0.3)) // تعبئة الدائرة باللون الأسود الشفاف
                            .frame(width: 40, height: 40) // حجم أصغر للدائرة
                    )
                    .overlay(
                        Circle() // دائرة حول الأيقونة
                            .stroke(Color.white, lineWidth: 1) // إضافة ستروك باللون السماوي
                            .frame(width: 40, height: 40) // نفس حجم الدائرة لضمان التناسق
                    )
                    .shadow(color: Color.orange.opacity(0.9), radius: 10)
                // إضافة الظل الأبيض مع تعديل الشفافية والاتجاه
      
            }
              Spacer()
          }
          .padding(.horizontal, 30)

          Text("Coins Shop")
            .font(.title.bold())
            .foregroundColor(.white)

          Text("Balance: \(gameData.playerProgress?.coins ?? 0) 💰")
            .foregroundColor(.white.opacity(0.8))

          // Your three packages
          HStack(spacing: 70) {
            coinOption(amount: 300, price: "5.99", imageName: "Coins")
            coinOption(amount: 150, price: "3.99", imageName: "TwoCoins")
              coinOption(amount:  75, price: "1.99", imageName: "Coin")
          }
          .padding()

    
        }
     

        //.frame(maxHeight: .infinity, alignment: .bottom)
        .padding()
        .background(
          ZStack {
            Color.black.opacity(0.5)
              .cornerRadius(20)
            .background(.ultraThinMaterial)
          }
        )
        .cornerRadius(20)
        .padding()
        .transition(.move(edge: .bottom))
      //}
      

    }
  }

  @ViewBuilder
  private func coinOption(amount: Int, price: String, imageName: String) -> some View {
    VStack {
      Text("\(amount)")
        .font(.title.bold())
        .foregroundColor(.white)
      Image(imageName)
        .resizable()
        .frame(width: 100, height: 100)
      Button {
        gameData.addCoins(amount)
      } label: {
        HStack(spacing: 5) {
          Image("riyal")
            .resizable()
            .frame(width: 20, height: 20)
          Text(price)
            .foregroundColor(.white)
        }
        .frame(width: 150, height: 50)
        .background(Color.black.opacity(0.4))
        .cornerRadius(10)
        .shadow(color: .white.opacity(0.9), radius: 10, x: 2, y: 2)
      }
    }
  }
}


#Preview {
    // 1. Create a preview GameDataStore
    let previewStore = GameDataStore()
    
    // 2. Configure sample progress data
    let progress = PlayerProgress()
    progress.currentTrackIndex = 1
    progress.currentLevelIndex = 2
    progress.coins = 150
    progress.completedLevels = ["Track1-Level1", "Track1-Level2"]
    previewStore.playerProgress = progress
    
    // 3. Create the view with environment
    return MapView()
        .environment(previewStore)
        .background(
            Image("bg") // Match your actual background image name
                .resizable()
                .ignoresSafeArea()
        )
}
