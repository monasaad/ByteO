import SwiftData
import SwiftUI

struct InfiniteLetterPicker: View {
    private let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    private let loopCount = 3
    var allLetters: [String] {
        Array(repeating: letters, count: loopCount).flatMap { $0 }.map { String($0) }
    }
    @Binding var selectedLetter: String
    @State private var selectedIndex: Int = 0

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
                .frame(width: 30, height: 30)
                .shadow(color: .white.opacity(0.1), radius: 2, x: 0, y: 1)

            Picker("", selection: $selectedIndex) {
                ForEach(0..<allLetters.count, id: \.self) { i in
                    Text(allLetters[i])
                        .font(.title2)
                        .frame(width: 40, height: 40)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 50, height: 120)
            .clipped()
            .onAppear {
                if let centerIndex = allLetters.firstIndex(of: selectedLetter) {
                    selectedIndex = 26 + centerIndex % 26
                }
            }
            .onChange(of: selectedIndex) { newValue in
                selectedLetter = allLetters[newValue % 26]
                if newValue <= 1 || newValue >= allLetters.count - 2 {
                    selectedIndex = 26 + (newValue % 26)
                }
            }
        }
    }
}
struct GameView: View {
    @Environment(GameDataStore.self) var gameData
    @Environment(\.dismiss) var dismiss

    @State private var slots: [String] = ["A", "A", "A", "A", "A"]
    @State private var showHint = false
    @State private var usedHint = false
    @State private var showResult = false
    @State private var isCorrect = false
    @State private var navigateToMap = false
    @State private var resetTimer: Timer?
    @State private var resetTimeText: String = ""

    @State private var showWalletPopup = false
    @State private var showAttemptsPopup = false
    @State private var showExitPopup = false
    @State private var animationOffset: CGFloat = -500
    @State private var navigateToMainMenu = false
    @State private var showHintPopup = true
    @State private var showAdPrompt = false

    @State private var showWinPopup = false
    @State private var showFailPopup = false
    @State private var showStoreSheet = false
    private func makeAttributedQuestion(
      question: String,
      highlight: String,
      highlightColor: Color
    ) -> AttributedString {
      var attr = (try? AttributedString(markdown: question))
                 ?? AttributedString(question)
      if let range = attr.range(of: highlight) {
        // the color of the encrypted message change based on color track
        attr[range].foregroundColor = highlightColor.opacity(0.9)
        // the encrypted message is bold
        attr[range].inlinePresentationIntent = .stronglyEmphasized

      }
      return attr
    }

    var body: some View {
        
        let progress = gameData.playerProgress
        let tracks = LevelData.allTracks

        let rawTrackIndex = progress?.currentTrackIndex ?? 0
        let trackIndex = min(max(0, rawTrackIndex), tracks.count - 1)
        let track = tracks[trackIndex]

        let rawLevelIndex = progress?.currentLevelIndex ?? 0
        let levels = track.levels
        let levelIndex = min(max(0, rawLevelIndex), levels.count - 1)
        let level = levels[levelIndex]
        let levelKey = gameData.levelKey(trackName: track.name, levelNumber: level.number)

        let attemptsUsed = progress?.failedAttempts[levelKey] ?? 0
        let remaining = max(3 - attemptsUsed, 0)
      
   
        ZStack {
            //TODO
            if showAdPrompt {
                CustomAlertView(
                    title: "Hint",
                    message: "\(level.hint)",

                    // if hints is used, change watch ad to Watch Ad
                    primaryButtonTitle: "Got it!",
                    secondaryButtonTitle: "Cancel",

                    primaryAction: {
                        // Handle ad watching logic
                        print("Start playing ad...")
                        showAdPrompt = false
                    },
                    secondaryAction: {
                        showAdPrompt = false
                    }
                )
                .transition(.scale.combined(with: .opacity))
                .zIndex(999)  // Ensure it's on top
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.4))
            }

            NavigationLink("", destination: MainMenuView(), isActive: $navigateToMainMenu).hidden()
            NavigationLink("", destination: MapView(), isActive: $navigateToMap).hidden()

            Color.white.opacity(0.9).edgesIgnoringSafeArea(.all).blur(radius: showHintPopup ? 5 : 0)

            Image("bg")
                .resizable()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 5) {
                Button(action: { showExitPopup = true }) {
                    Image(systemName: "chevron.backward.circle.fill")
                        .font(.title)
                        .foregroundColor(.c3)
                        .frame(width: 50, height: 50)
                        .background(Color.white.opacity(0.4))
                        .clipShape(Circle())
                }
                .alert("Do you want to exit the game?", isPresented: $showExitPopup) {
                    Button("Yes", role: .destructive) { navigateToMainMenu = true }
                    Button("Cancel", role: .cancel) {}
                }

                //                Button(action: { showWalletPopup = true }) {
                //                    HStack {
                //                        Image(systemName: "wallet.bifold.fill")
                //                            .foregroundColor(.white)
                //                        Text(" \(progress?.coins ?? 0)")
                //                            .foregroundColor(.white)
                //                            .font(.headline)
                //                    }
                //                    .padding(8)
                //                    .background(Color.white.opacity(0.4))
                //                    .cornerRadius(12)
                //                }
                //                .alert("Your current balance is: \(progress?.coins ?? 0) coins", isPresented: $showWalletPopup) {
                //                    Button("OK", role: .cancel) {}
                //                }

                //                Button(action: { showAttemptsPopup = true }) {
                //                    HStack {
                //                        Image(systemName: "pawprint.fill")
                //                            .foregroundColor(.white)
                //                        Text(" \(remaining)x ").foregroundColor(.white).font(.headline)
                //                    }
                //                    .padding(8)
                //                    .background(Color.white.opacity(0.4))
                //                    .cornerRadius(12)
                //                }
                //                .alert("You have \(remaining) attempts", isPresented: $showAttemptsPopup) {
                //                    Button("OK", role: .cancel) {}
                //                }
            }
            .padding(.leading, -400)
            .padding(.bottom, 300)

            VStack {
                HStack(alignment: .top, spacing: -15) {
                    ZStack {

                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(track.color).opacity(0.8), lineWidth: 1.8))
                            .shadow(color: track.color.opacity(0.5), radius: 8, x: 0, y: 5)

                        VStack(alignment: .leading, spacing: 7) {
                            Text("\(track.name) - Level \(level.number)")
                                .font(.system(size: 18, weight: .bold, design: .monospaced))
                                .foregroundColor(track.color)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(level.station)")
                                .font(.system(size: 18, weight: .bold, design: .monospaced))
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.leading)  // النص يبدأ من اليسار
                                .lineLimit(nil)  // عدد غير محدود من الأسطر
                                .fixedSize(horizontal: false, vertical: true)  // التفاف تلقائي
                                .frame(maxWidth: .infinity, alignment: .leading)
                       

                            // Single Text that applies all your styling
                            Text(
                              makeAttributedQuestion(
                                question: level.question,
                                highlight: level.encryptedText,
                                highlightColor: track.color
                              )
                            )
                            .font(.system(size: 16, design: .monospaced))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Text("The key : \(level.key)")
                                .font(.system(size: 16, design: .monospaced))
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)

                         // النص يبدأ من اليسار
                                .lineLimit(nil)  // عدد غير محدود من الأسطر
                                .fixedSize(horizontal: false, vertical: true)  // التفاف تلقائي
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        //.padding(.bottom, 20)
                        .padding()
                        .offset(x: animationOffset)
                        .onAppear {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.5)) {
                                animationOffset = 0
                            }
                        }
                        .frame(width: 500, height: 100)

                        //TODO
                        //                        Button(action: {
                        //                            if !usedHint && !(progress?.hintsUsed.contains(levelKey) ?? false) {
                        //                                usedHint = gameData.useHint(for: levelKey)
                        //                                showHint = true
                        //                            } else {
                        //                                showAdPrompt = true
                        //                            }
                        //                        }) {
                        //                            ZStack {
                        //                                Circle().fill(Color.c2.opacity(0.99)).frame(width: 50, height: 50)
                        //                                Image(systemName: "lightbulb.fill")
                        //                                    .font(.title)
                        //                                    .frame(width: 50, height: 50)
                        //                                    .foregroundColor(.white)
                        //                            }
                        //                        }
                        //                        .alert("Alert", isPresented: $showAdPrompt) {
                        //                            Button("OK") {}
                        //                        } message: {
                        //                            Text("To unlock another hint, you need to watch an Ad")
                        //                        }
                        //                        .padding(.leading, -320)
                        //                        .padding(.bottom, 70)
                        //                        .transition(.move(edge: .bottom))
                        //                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: showHintPopup)
                        Button(action: {
                            if !usedHint && !(progress?.hintsUsed.contains(levelKey) ?? false) {
                                usedHint = gameData.useHint(for: levelKey)
                                showHint = true
                            } else {
                                showAdPrompt = true
                            }
                        }) {
                            ZStack {
                                Circle().fill(Color.c2.opacity(0.99)).frame(width: 50, height: 50)
                                Image(systemName: "lightbulb.fill")
                                    .font(.title)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                            }
                        }
                        // REMOVE THE OVERLAY FROM HERE
                        .padding(.leading, -320)
                        .padding(.bottom, 70)
                        .transition(.move(edge: .bottom))
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: showHintPopup)

                    }

                    .frame(width: 450, height: 130)

                    Image("robot_zero")
                        .resizable()
                        .frame(width: 160, height: 160)
                        .alignmentGuide(.top) { _ in 0 }
                        .offset(x: animationOffset, y: -30)
                        .transition(.scale)
                        .onAppear {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.5)) {
                                animationOffset = 0
                            }
                        }
                }
                .padding(.trailing, -250)
                .padding(.top, 50)

                VStack(spacing: -10) {
                    Text(slots.joined())
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                        .padding()
                        .frame(maxWidth: 250)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)

                    HStack(alignment: .top, spacing: 10) {
                        ForEach(slots.indices, id: \.self) { index in
                            InfiniteLetterPicker(selectedLetter: $slots[index])
                        }
                    }
                    
                    Button("Submit") {
                        let result = slots.joined().trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
                        let correctAnswer = level.correctAnswer.uppercased()

                        if result == correctAnswer {
                            isCorrect = true
                            showResult = true
                            gameData.markLevelCompleted(levelKey)
                            gameData.addCoins(10)

                            // Move to next level after delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                gameData.moveToNextLevel(totalLevels: track.levels.count)
                                navigateToMap = true
                            }
                        } else {
                            isCorrect = false
                            showResult = true
                            gameData.registerFailedAttempt(for: levelKey)
                        }
                    }
                    .alert(isCorrect ? "Correct! 🎉" : "Try Again ❌", isPresented: $showResult) {
                        Button("OK") {
                            if isCorrect {
                                // Reset slots for next level
                                slots = Array(repeating: "A", count: slots.count)
                            }
                        }
                    } message: {
                        Text(
                            isCorrect ? "You earned it! Next level is waiting!" : "Keep trying!"
                        )
                    }
                    //.buttonStyle(PrimaryButtonStyle(backgroundColor:Color.c3))
                    .buttonStyle(SecondaryButtonStyle(color:track.color))
                                        .padding(.leading, 600)
                                        .padding(.bottom, 40)

                    //                    Button("Submit") {
                    //                        let result = slots.joined().trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
                    //                        let correctAnswer = level.correctAnswer.uppercased()
                    //
                    //
                    //                        if remaining > 0 {
                    //                            if result == correctAnswer {
                    //                                isCorrect = true
                    //                                showWinPopup = true
                    //                                gameData.markLevelCompleted(levelKey)
                    //                                gameData.addCoins(10)
                    //                            } else {
                    //                                isCorrect = false
                    //                                showFailPopup = true
                    //                                gameData.registerFailedAttempt(for: levelKey)
                    //                            }
                    //                        } else {
                    //                            showFailPopup = true
                    //                        }
                    //                    }
                    //                    .padding()
                    //                    .font(.system(size: 20, weight: .semibold))
                    //                    .foregroundColor(.white)
                    //                    .padding(.horizontal, 10)
                    //                    .background(
                    //                        RoundedRectangle(cornerRadius: 20)
                    //                            .fill(Color.c4)
                    //                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.c4.opacity(0.4)))
                    //                            .shadow(color: Color.c4, radius: 10, x: 8, y: 8)
                    //                    )
                    //                    .padding(.leading, 600)
                    //                    .padding(.bottom, 40)

                }
            }

            // Show Win Popup
            if showWinPopup {
                WinPopup(
                    isPresented: $showWinPopup,
                    attemptsUsed: attemptsUsed,
                    onContinue: {
                        let totalLevels = track.levels.count
                        let totalTracks = tracks.count

                        if trackIndex < totalTracks {
                            if levelIndex + 1 < totalLevels {
                                gameData.playerProgress?.currentLevelIndex = levelIndex + 1
                            } else if trackIndex + 1 < totalTracks {
                                gameData.playerProgress?.currentTrackIndex = trackIndex + 1
                                gameData.playerProgress?.currentLevelIndex = 0
                            }
                        }

                        gameData.save()
                        navigateToMap = true
                    },
                    onMainMenu: {
                        navigateToMainMenu = true
                    }
                )
            }

            // Show Fail Popup
            if showFailPopup {
                FailPopup(
                    isPresented: $showFailPopup,
                    attemptsRemaining: remaining,
                    onRetry: {
                        showFailPopup = false
                    },
                    onWait: {
                        showFailPopup = false
                    },
                    onBuyCoins: {
                        showFailPopup = false
                        showStoreSheet = true

                        // افتح شاشة المتجر
                        if gameData.useCoins(50) {
                            let current = gameData.playerProgress?.failedAttempts[levelKey] ?? 0
                            if current > 0 {
                                gameData.playerProgress?.failedAttempts[levelKey] = current - 1
                            } else {
                                gameData.playerProgress?.failedAttempts[levelKey] = 0
                            }
                            gameData.save()
                        }
                    },
                    navigateToMainMenu: {
                        navigateToMainMenu = true
                    }
                )
            }
            // MARK: to be
            if showStoreSheet {
                //  Color.black.opacity(0.5)
                // .ignoresSafeArea()
                //   .transition(.opacity)

                CoinStoreView(isPresented: $showStoreSheet)

                    //.frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
            }
        }
        .animation(.spring(), value: showStoreSheet)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        //        .sheet(isPresented: $showStoreSheet) {
        //            CoinStoreView(isPresented: .constant(true))
        //                .environment(gameData)  // تمرير environment
        //        }
        // במקום .sheet:

        //        // ── Overlay pop-up ──
        //        if showStoreSheet {
        //            CoinStoreView(isPresented: $showStoreSheet)
        //                .zIndex(1)
        //        }

    }

    func timeUntilReset(lastDate: Date) -> String {
        let now = Date()
        let resetDate = Calendar.current.date(byAdding: .hour, value: 24, to: lastDate) ?? now
        let diff = Calendar.current.dateComponents([.hour, .minute], from: now, to: resetDate)

        let h = diff.hour ?? 0
        let m = diff.minute ?? 0
        return String(format: "%02d ساعة و %02d دقيقة", h, m)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environment(GameDataStore.shared)
    }
}
