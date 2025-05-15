//
////  gameScreen.swift
////  ByteO
////
////  Created by atheer alshareef on 06/05/2025.

import SwiftUI
import SwiftData
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
            // الخلفية الزجاجية لمربع الحرف المختار
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
import SwiftUI
import SwiftData

struct DecryptionGameView: View {
  @Environment(\.modelContext) private var context
  @Query private var stores: [GameDataStore]
  private var store: GameDataStore { stores.first! }

  @State private var slots: [String] = []
  @State private var questionIndex = 0
  @State private var showLose = false
  @State private var showOut = false

  private var questions: [Question] {
    QuestionBank.shared.questionsByLevel[store.currentLevel] ?? []
  }

  var body: some View {
    NavigationView {
      ZStack {
        Image("bg").resizable().ignoresSafeArea()

        if questions.isEmpty {
          Text("لا توجد أسئلة لهذا المستوى")
            .foregroundColor(.white)
            .font(.title2)
        } else {
          // عرض السؤال الحالي
          let q = questions[questionIndex]
          VStack(spacing: 20) {
            Text(q.questionText)
              .foregroundColor(.white)
              .font(.headline)

            Text("Key: \(q.key)")
              .foregroundColor(.white.opacity(0.8))

            HStack {
              ForEach(slots.indices, id: \.self) { i in
                InfiniteLetterPicker(selectedLetter: $slots[i])
              }
            }

            Button("Submit") {
              handleSubmit(for: q)
            }
            .disabled(store.player.attempts == 0)
            .padding()
            .background(Color.purple.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(12)
            .alert("خاطئ", isPresented: $showLose) {
              Button("حسناً") {}
            }
            .alert("نفدت محاولاتك", isPresented: $showOut) {
              Button("انتظر لبكرة", role: .cancel) {
                store.player.attempts = 3
                resetForCurrentLevel()
              }
            } message: {
              Text("يمكنك شراء محاولات لاحقاً.")
            }
          }
          .padding()
        }
      }
      .toolbar {
        Button { /* خروج */ } label: { Image(systemName: "arrow.left") }
        Spacer()
        Text("Coins: \(store.player.coins)")
        Spacer()
        Text("Attempts: \(store.player.attempts)")
      }
      .onAppear { resetForCurrentLevel() }
      .onChange(of: store.currentLevel) { _ in resetForCurrentLevel() }
    }
  }

  private func resetForCurrentLevel() {
    // إعادة ضبط المؤشر والحروف عند كل مستوى
    questionIndex = 0
    let count = questions.first?.correctAnswer.count ?? 5
    slots = Array(repeating: "A", count: count)
  }

  private func handleSubmit(for q: Question) {
    if slots.joined() == q.correctAnswer {
      // صحيح → سؤال تالي أو مستوى تالي
      if questionIndex + 1 < questions.count {
        questionIndex += 1
        slots = Array(repeating: "A", count: slots.count)
      } else {
        // انتهى هذا المستوى
        store.levels[store.currentLevel - 1].isCompleted = true
        store.currentLevel += 1
      }
    } else {
      // خاطئ → طرح محاولة
      store.player.attempts -= 1
      if store.player.attempts > 0 {
        showLose = true
      } else {
        showOut = true
      }
    }
  }
}

#Preview {
  DecryptionGameView()
    .modelContainer(for: [
      Player.self,
      Settings.self,
      Level.self,
      Achievement.self,
      GameDataStore.self
    ])
}


//last
//import SwiftUI
//import SwiftData
//
//struct DecryptionGameView: View {
//    @Query private var stores: [GameDataStore]
//      @Environment(\.modelContext) private var context
//
//      private var gameData: GameDataStore {
//        stores.first!   // لأننا أنشأنا واحد فقط
//      }
//    @State private var slots: [String]
//    @State private var showWalletPopup = false
//    @State private var showAttemptsPopup = false
//    @State private var showExitPopup = false
//    @State private var showWinPopup = false
//    @State private var showLosePopup = false
//    @State private var showHintPopup = false
//    @State private var showOutOfAttemptsPopup = false
//    @State private var navigateToMainMenu = false
//    @State private var navigateToNextLevel = false  // للتنقل للصفحة التالية
//    @State private var animationOffset: CGFloat = -500
//    @Environment(\.dismiss) var dismiss
//
//    @State private var questionIndex: Int = 0
//
//    private var questions: [Question] {
//        QuestionBank.shared.questionsByLevel[gameData.currentLevel] ?? []
//    }
//
//    var currentQuestion: Question {
//        questions.indices.contains(questionIndex)
//            ? questions[questionIndex]
//            : questions.first!
//    }
//
//    init(gameData: GameDataStore) {
//        self.gameData = gameData
//        let length = QuestionBank
//            .shared.questionsByLevel[gameData.currentLevel]?
//            .first?.correctAnswer.count ?? 5
//        _slots = State(initialValue: Array(repeating: "A", count: length))
//    }
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                // انتقال للمرحلة التالية
//                // ✅ هذا هو الشكل الصحيح
//                NavigationLink(
//                    destination: mapView(gameData: gameData),
//                    isActive: $navigateToNextLevel
//                ) {
//                    EmptyView()
//                }
//                // انتقال للقائمة الرئيسية
//                NavigationLink( destination: MainMenuView(), isActive: $navigateToMainMenu) { EmptyView() }
//
//                Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
//                Image("bg").resizable().edgesIgnoringSafeArea(.all)
//
//                VStack(spacing: 5) {
//                    Button { showExitPopup = true } label: {
//                        Image(systemName: "chevron.backward.circle.fill")
//                            .font(.title).foregroundColor(.purple)
//                            .frame(width: 50, height: 50)
//                            .background(Color.white.opacity(0.15)).clipShape(Circle())
//                    }
//                    .alert("هل تريد الخروج من اللعبة؟", isPresented: $showExitPopup) {
//                        Button("نعم", role: .destructive) { navigateToMainMenu = true }
//                        Button("إلغاء", role: .cancel) {}
//                    }
//
//                    Button { showWalletPopup = true } label: {
//                        HStack {
//                            Image(systemName: "wallet.bifold.fill").foregroundColor(.white)
//                            Text("\(gameData.player.coins)").foregroundColor(.white).font(.headline)
//                        }
//                        .padding(8).background(Color.white.opacity(0.15)).cornerRadius(12)
//                    }
//                    .alert("رصيدك الحالي هو: \(gameData.player.coins) كوينز", isPresented: $showWalletPopup) {
//                        Button("موافق", role: .cancel) {}
//                    }
//
//                    Button { showAttemptsPopup = true } label: {
//                        HStack {
//                            Image(systemName: "pawprint.fill").foregroundColor(.white)
//                            Text("\(gameData.player.attempts)x").foregroundColor(.white).font(.headline)
//                        }
//                        .padding(8).background(Color.white.opacity(0.15)).cornerRadius(12)
//                    }
//                    .alert("لديك \(gameData.player.attempts) محاولات متبقية", isPresented: $showAttemptsPopup) {
//                        Button("موافق", role: .cancel) {}
//                    }
//                }
//                .padding(.leading, -410).padding(.bottom, 180)
//
//                HStack(alignment: .top, spacing: -40) {
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 20)
//                            .fill(.ultraThinMaterial)
//                            .overlay(RoundedRectangle(cornerRadius: 20)
//                                .stroke(Color.c2.opacity(0.8), lineWidth: 1.8)
//                            )
//                            .shadow(color: Color.cyan.opacity(0.3), radius: 10, x: 0, y: 5)
//
//                        VStack(alignment: .leading, spacing: 5) {
//                            Text("Mission \(gameData.currentLevel) — Level \(questionIndex+1)")
//                                .font(.system(size: 18, weight: .bold, design: .monospaced))
//                                .foregroundColor(.white)
//
//                            Text(currentQuestion.questionText)
//                                .font(.system(size: 16, design: .monospaced))
//                                .foregroundColor(.white.opacity(0.9))
//
//                            Text("Key: \(currentQuestion.key)")
//                                .font(.system(size: 16, design: .monospaced))
//                                .foregroundColor(.white.opacity(0.9))
//                        }
//                        .padding().offset(x: animationOffset)
//
//                        Button { showHintPopup = true } label: {
//                            Circle().fill(Color.c2).frame(width: 50, height: 50)
//                            Image(systemName: "lightbulb.fill").foregroundColor(.white)
//                        }
//                        .padding(.leading, -320).padding(.bottom, 50)
//                    }
//                    .frame(width: 500, height: 130)
//
//                    Image("robot_zero").resizable()
//                        .frame(width: 200, height: 200)
//                        .padding(.leading, -20).offset(x: animationOffset)
//                }
//                .padding(.trailing, -40).padding(.bottom, 140)
//                .alert("💡 تلميح المهمة", isPresented: $showHintPopup) {
//                    Button("موافق") {}
//                } message: {
//                    Text(currentQuestion.hint)
//                }
//
//                VStack(spacing: -15) {
//                    Text(slots.joined())
//                        .font(.system(size: 20, weight: .medium, design: .rounded))
//                        .foregroundColor(.white.opacity(0.8))
//                        .padding().frame(maxWidth: 250)
//                        .background(.ultraThinMaterial).cornerRadius(12)
//
//                    HStack(spacing: 5) {
//                        ForEach(slots.indices, id: \.self) { idx in
//                            InfiniteLetterPicker(selectedLetter: $slots[idx])
//                        }
//                    }
//
//                    Button("Submit") {
//                        let attempt = slots.joined()
//                        if attempt == currentQuestion.correctAnswer {
//                            showWinPopup = true
//                        } else {
//                            gameData.player.attempts -= 1
//                            if gameData.player.attempts <= 0 {
//                                showOutOfAttemptsPopup = true
//                            } else {
//                                showLosePopup = true
//                            }
//                        }
//                    }
//                    .disabled(gameData.player.attempts <= 0)
//                    .padding()
//                    .background(Color.purple.opacity(0.7))
//                    .foregroundColor(.white)
//                    .cornerRadius(12)
//                    .padding(.leading, 500)
//                }
//                .alert("🎉 مبروك! فزت!", isPresented: $showWinPopup) {
//                    // إذا فيه سؤال تالي
//                    if questionIndex + 1 < questions.count {
//                        Button("التالي") {
//                            questionIndex += 1
//                            resetSlots()
//                        }
//                    } else {
//                        Button("التالي") {
//                            gameData.levels[gameData.currentLevel-1].isCompleted = true
//                            gameData.currentLevel += 1
//                            navigateToNextLevel = true
//                        }
//                    }
//                }
//                .alert("😔 انتهت محاولاتك", isPresented: $showOutOfAttemptsPopup) {
//                    Button("شراء محاولات") {
//                        // IAP لاحقًا
//                    }
//                    Button("انتظر لبكرة", role: .cancel) {
//                        gameData.player.attempts = 3
//                        dismiss()
//                    }
//                } message: {
//                    Text("يمكنك شراء محاولات جديدة أو المحاولة غدًا.")
//                }
//            }
//        }
//    }
//
//    private func resetSlots() {
//        slots = Array(repeating: "A", count: slots.count)
//    }
//}
//
//#Preview {
//    DecryptionGameView(gameData: GameDataStore())
//}

//
//import SwiftUI
//import SwiftData
//
//struct DecryptionGameView: View {
//    @ObservedObject var gameData: GameDataStore
//    @State private var slots: [String]
//    @State private var showWalletPopup = false
//    @State private var showAttemptsPopup = false
//    @State private var showExitPopup = false
//    @State private var showWinPopup = false
//    @State private var showLosePopup = false
//    @State private var showHintPopup = false
//    @State private var navigateToMainMenu = false
//    @State private var animationOffset: CGFloat = -500
//    @State private var isShowingHint: Bool = false
//    @State private var showOutOfAttemptsPopup = false
//    @Environment(\.dismiss) var dismiss
//
//    // تتبع أي سؤال حالياً
//    @State private var questionIndex: Int = 0
//
//    // قائمة الأسئلة للمستوى الحالي
//    private var questions: [Question] {
//        QuestionBank.shared.questionsByLevel[gameData.currentLevel] ?? []
//    }
//    // إذا ما فيه أسئلة، نرجّع سؤال افتراضي حتى لا ينهار
//    private var currentQuestion: Question {
//        guard questionIndex < questions.count else {
//            return Question(
//               questionText: "-", correctAnswer: "AAAAA", key: "", hint: "", hintUsesAllowed: 0
//            )
//        }
//        return questions[questionIndex]
//    }
//
//    // تهيئة slots حسب طول الإجابة لأول سؤال
//    init(gameData: GameDataStore) {
//        self.gameData = gameData
//        let length = QuestionBank
//          .shared.questionsByLevel[gameData.currentLevel]?
//          .first?.correctAnswer.count ?? 5
//        _slots = State(initialValue: Array(repeating: "A", count: length))
//    }
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
//                Image("bg").resizable().edgesIgnoringSafeArea(.all)
//
//                // ────── شريط التحكم العلوي ──────
//                VStack(spacing: 5) {
//                    // خروج
//                    Button { showExitPopup = true } label: {
//                        Image(systemName: "chevron.backward.circle.fill")
//                            .font(.title).foregroundColor(.purple)
//                            .frame(width: 50, height: 50)
//                            .background(Color.white.opacity(0.15)).clipShape(Circle())
//                    }
//                    .alert("هل تريد الخروج من اللعبة؟", isPresented: $showExitPopup) {
//                        Button("نعم", role: .destructive) { navigateToMainMenu = true }
//                        Button("إلغاء", role: .cancel) {}
//                    }
//                    // خيار 1 – استخدام initializer الذي يأخذ isActive ثم label:
//                    NavigationLink(isActive: $navigateToMainMenu) {
//                      MainMenuView()
//                    } label: {
//                      EmptyView()
//                    }
//
//                    // المحفظة
//                    Button { showWalletPopup = true } label: {
//                        HStack {
//                            Image(systemName: "wallet.bifold.fill").foregroundColor(.white)
//                            Text("\(gameData.player.coins)").foregroundColor(.white).font(.headline)
//                        }
//                        .padding(8).background(Color.white.opacity(0.15)).cornerRadius(12)
//                    }
//                    .alert("رصيدك الحالي هو: \(gameData.player.coins) كوينز", isPresented: $showWalletPopup) {
//                        Button("موافق", role: .cancel) {}
//                    }
//
//                     // المحاولات
//                    Button { showAttemptsPopup = true } label: {
//                        HStack {
//                            Image(systemName: "pawprint.fill").foregroundColor(.white)
//                            Text("\(gameData.player.attempts)x").foregroundColor(.white).font(.headline)
//                        }
//                        .padding(8).background(Color.white.opacity(0.15)).cornerRadius(12)
//                    }
//                    .alert("لديك \(gameData.player.attempts) محاولات متبقية", isPresented: $showAttemptsPopup) {
//                        Button("موافق", role: .cancel) {}
//                    }
//                }
//                .padding(.leading, -410).padding(.bottom, 180)
//
//                // ────── بطاقة السؤال ──────
//                HStack(alignment: .top, spacing: -40) {
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 20)
//                            .fill(.ultraThinMaterial)
//                            .overlay(RoundedRectangle(cornerRadius: 20)
//                                .stroke(Color.c2.opacity(0.8), lineWidth: 1.8)
//                            )
//                            .shadow(color: Color.cyan.opacity(0.3), radius: 10, x: 0, y: 5)
//
//                        VStack(alignment: .leading, spacing: 5) {
//                            Text("Mission \(gameData.currentLevel) — Level \(questionIndex+1)")
//                                .font(.system(size: 18, weight: .bold, design: .monospaced))
//                                .foregroundColor(.white)
//
//                            Text(currentQuestion.questionText)
//                                .font(.system(size: 16, design: .monospaced))
//                                .foregroundColor(.white.opacity(0.9))
//
//                            Text("Key: \(currentQuestion.key)")
//                                .font(.system(size: 16, design: .monospaced))
//                                .foregroundColor(.white.opacity(0.9))
//                        }
//                        .padding().offset(x:  animationOffset)
//
//                        // تلميح
//                        Button { showHintPopup = true } label: {
//                            Circle().fill(Color.c2).frame(width: 50, height: 50)
//                            Image(systemName: "lightbulb.fill").foregroundColor(.white)
//                        }
//                        .padding(.leading, -320).padding(.bottom, 50)
//                    }
//                    .frame(width: 500, height: 130)
//
//                    // صورة الروبوت
//                    Image("robot_zero").resizable()
//                        .frame(width: 200, height: 200)
//                        .padding(.leading, -20).offset(x: animationOffset)
//                }
//                .padding(.trailing, -40).padding(.bottom, 140)
//                .alert("💡 تلميح المهمة", isPresented: $showHintPopup) {
//                    Button("موافق") {
//                        // خصم استخدام هنت
//                    }
//                } message: {
//                    Text(currentQuestion.hint)
//                }
//
//                // ────── واجهة الحروف ──────
//                VStack(spacing: -15) {
//                    Text(slots.joined())
//                        .font(.system(size: 20, weight: .medium, design: .rounded))
//                        .foregroundColor(.white.opacity(0.8))
//                        .padding().frame(maxWidth: 250)
//                        .background(.ultraThinMaterial).cornerRadius(12)
//
//                    HStack(spacing: 5) {
//                        ForEach(slots.indices, id: \.self) { idx in
//                            InfiniteLetterPicker(selectedLetter: $slots[idx])
//                        }
//                    }
//
//                  
//
//                    // Submit
//                    Button("Submit") {
//                        let attempt = slots.joined()
//                        if attempt == currentQuestion.correctAnswer {
//                            showWinPopup = true
//                        } else {
//                            gameData.player.attempts -= 1
//                            if gameData.player.attempts <= 0 {
//                                showOutOfAttemptsPopup = true
//                            } else {
//                                showLosePopup = true
//                            }
//                        }
//                    }
//                    .disabled(gameData.player.attempts <= 0)
//                    .padding()
//                    .background(Color.purple.opacity(0.7))
//                    .foregroundColor(.white)
//                    .cornerRadius(12)
//                    .padding(.leading, 500)
//                }
//                // فوز
//                .alert("🎉 مبروك! فزت!", isPresented: $showWinPopup) {
//                    Button("التالي") {
//                        if questionIndex + 1 < questions.count {
//                            questionIndex += 1
//                            resetSlots()
//                        } else {
//                            // أكمل المستوى
//                            gameData.levels[gameData.currentLevel-1].isCompleted = true
//                            gameData.currentLevel += 1
//                            dismiss()
//                        }
//                    }
//                }
//                // نفدت المحاولات
//                .alert("😔 عدد محاولاتك انتهى", isPresented: $showOutOfAttemptsPopup) {
//                    Button("شراء محاولات") {
//                        // IAP لاحقًا
//                    }
//                    Button("انتظر لبكرة", role: .cancel) {
//                        dismiss()
//                    }
//                } message: {
//                    Text("يمكنك شراء محاولات جديدة أو المحاولة غدًا.")
//                }
//            }
//        }
//    }
//    private func resetSlots() {
//        slots = Array(repeating: "A", count: slots.count)
//    }
//}
//
//#Preview {
//    DecryptionGameView(gameData: GameDataStore())
//}
//















//import SwiftUI

//
//struct DecryptionGameView: View {
//    @ObservedObject var gameData: GameDataStore
//    @State private var message: String = ""
//    @State private var key: Int = 3
//    @State private var slots = ["A", "A", "A", "A", "A"]
//    @State private var showWalletPopup = false
//    @State private var showAttemptsPopup = false
//    @State private var showExitPopup = false
//    @State private var showWinPopup = false
//    @State private var showLosePopup = false
//    @State private var showHintPopup = false
//    @State private var navigateToMainMenu = false
//    @State private var currentLevelIndex: Int = 0
//    @Environment(\.dismiss) var dismiss
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                Color.black.opacity(0.6)
//                    .edgesIgnoringSafeArea(.all)
//
//                Image("bg")
//                    .resizable()
//                    .edgesIgnoringSafeArea(.all)
//
//                VStack(spacing: 5) {
//                    Button(action: {
//                        showExitPopup = true
//                    }) {
//                        Image(systemName: "chevron.backward.circle.fill")
//                            .font(.title)
//                            .foregroundColor(.purple)
//                            .frame(width: 50, height: 50)
//                            .background(Color.white.opacity(0.15))
//                            .clipShape(Circle())
//                    }
//                    .alert("هل تريد الخروج من اللعبة؟", isPresented: $showExitPopup) {
//                        Button("نعم", role: .destructive) {
//                            navigateToMainMenu = true
//                        }
//                        Button("إلغاء", role: .cancel) {}
//                    }
//
//                    // 🟢 زر المحفظة (النقاط أو الرصيد)
//                    Button(action: {
//                        showWalletPopup = true
//                    }) {
//                        HStack {
//                            Image(systemName: "wallet.bifold.fill")
//                                .foregroundColor(.white)
//                            Text("\(gameData.player.coins)")
//                                .foregroundColor(.white)
//                                .font(.headline)
//                        }
//                        .padding(8)
//                        .background(Color.white.opacity(0.15))
//                        .cornerRadius(12)
//                    }
//                    .alert("رصيدك الحالي هو: \(gameData.player.coins) كوينز", isPresented: $showWalletPopup) {
//                        Button("موافق", role: .cancel) {}
//                    }
//                }
//                .padding(.bottom, 150)
//                // 🔄 التحكم في الحروف
//                HStack(alignment: .top, spacing: 5) {
//                    ForEach(slots.indices, id: \ .self) { index in
//                        InfiniteLetterPicker(selectedLetter: $slots[index])
//                    }
//                }
//
//                Button("Submit") {
//                    let result = slots.joined()
//                    if result == gameData.levels[currentLevelIndex].correctAnswer {
//                        showWinPopup = true
//                        currentLevelIndex += 1
//                    } else {
//                        showLosePopup = true
//                    }
//                }
//                .padding()
//                .background(Color.purple.opacity(0.7))
//                .foregroundColor(.white)
//                .cornerRadius(12)
//                .padding(.top, 150)
//                // ✅ Popup الفوز
//                .alert("🎉 مبروك! فزت!", isPresented: $showWinPopup) {
//                    Button("التالي") {
//                        if currentLevelIndex < gameData.levels.count {
//                            message = gameData.levels[currentLevelIndex].question
//                        } else {
//                            dismiss()
//                        }
//                    }
//                }
//
//                // ✅ Popup الخسارة
//                .alert("❌ للأسف، الكلمة غير صحيحة", isPresented: $showLosePopup) {
//                    Button("حاول مجددًا", role: .cancel) {}
//                }
//
//            }
//        }
//    }
//}

//
//#Preview {
//    DecryptionGameView(gameData: GameDataStore())
//}
