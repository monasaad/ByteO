import Foundation
import SwiftData
import SwiftUI

@Model
class PlayerProgress {
    var currentTrackIndex: Int = 0
    var currentLevelIndex: Int = 0
    var coins: Int = 0
    var failedAttempts: [String: Int] = [:]
    var hintsUsed: [String] = []
    var completedLevels: [String] = []
    var hasSeenIntro: Bool = false
    var lastResetDate: Date
    var achievementsUnlocked: [String] = []

    init() {
        self.lastResetDate = Date()  // ✅ حطيناها هنا بدلاً من .now مباشرة
    }
}

// Level
struct StaticLevel: Identifiable {
    let id = UUID()
    let number: Int
    let station: String
    let question: String
    let encryptedText: String
    let key: String
    let correctAnswer: String
    let hint: String
    // إذا حبيت تضيف لاحقاً:
    // let points: Int
    // let timeLimit: Int?
    // let imageName: String?
}

// Line
struct LevelTrack: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
    let levels: [StaticLevel]
}

struct LevelData {
    static let allTracks: [LevelTrack] = [
        
        // Yellow Line
        LevelTrack(
            name: "Yellow Line",
            color: .yellow,
            levels: [
                //
                StaticLevel(
                    number: 1,
                    station:"Terminal Station",
                    question:"Seek me where princesses pursue knowledge at PQWTC",
                    encryptedText:"PQWTC",
                    key:"-2",
                    correctAnswer: "NOURA",// NOURA
                    hint: "Shift each letter back 2 places to reveal the 5-letter name of your next stop"
                ),
                StaticLevel(
                    number: 2,
                    station:"PNU Station",
                    question: "Ha! You made it this far—now race to WEFMG before I get bored",
                    encryptedText:"WEFMG",
                    key:"-4" ,
                    correctAnswer: "SABIC",// SABIC
                    hint: "Shift each letter back 4 places to reveal the 5-letter name of your next stop"
                ),
                
                
                StaticLevel(
                    number: 3,
                    station: "SABIC Station",
                    question: "I’m watching you from a WRZHU",
                    encryptedText:"WRZHU",
                    key:"-3" ,
                    correctAnswer: "TOWER",// TOWER
                    hint: "Shift each letter back 3 places to reveal the 5-letter name of your next stop"
                
                ),
            ]
        ),
        
        // 🟦 المسار الأزرق
        LevelTrack(
            name: "Teal Line",
            color: .teal,
            levels: [
                StaticLevel(
                    number: 1,
                    station: "King Abdullah Financial District Station",
                    question: "See you at RODBD",
                    encryptedText: "RODBD",
                    key: "-3",
                    correctAnswer: "OLAYA",  //OLAYA
                    hint: "Shift each letter back 3 places to reveal the 5-letter name of your next stop"
                ),
                StaticLevel(
                    number: 2,
                    station: "OLAYA Station",
                    question: "Try to find me in GRUAJ!",
                    encryptedText: "GRUAJ",
                    key: "-6",
                    correctAnswer: "ALOUD", //ALOUD
                    hint: "Shift each letter back 6 places to reveal the 5-letter name of your next stop. Where heritage meets the tracks! This station carries the scent of history"
                ),
                
                
                
                StaticLevel(
                    number: 3,
                    station: "ALOUD Station",
                    question:"XGHKG is the station where the desert blooms.",
                    encryptedText:"XGHKG",
                    key: "-6",
                    correctAnswer: "RABEA", //AL RABEA
                    hint: "Shift each letter back 6 places to reveal the 5-letter name of your next stop. "
                ),
           
            ]
        ),
        //Purple line
        LevelTrack(
            name: "Purple line",
            color: .purple,
            levels: [
                StaticLevel(
                    number: 1,
                    station: "AL RABEA Station",
                    question:"ByteO, If step into OHTYH. I’ll paint the tracks with your blood.",
                    encryptedText: "OHTYH",
                    key:"-7",
                    correctAnswer: "HAMRA",  // HAMRA
                    hint: "Shift each letter back 7 places to reveal the 5-letter name of your next stop"
                ),
                StaticLevel(
                    number: 2,
                    station: "AL HAMRA Station",
                    question: "ByteO, wanna finally see me? let meet at AITIU.",
                    encryptedText: "AITIU",
                    key:"-8",
                    correctAnswer: "SALAM", //
                    hint: "Each letter moved back 8. Romantic capital of France."
                ),
            ]
        ),
    ]
}


@Observable
class GameDataStore {
    @MainActor
    static let shared = GameDataStore()

    var context: ModelContext
    var playerProgress: PlayerProgress?

    init() {
        let container = try! ModelContainer(for: PlayerProgress.self)
        self.context = ModelContext(container)

        Task {
            await self.loadProgress()
        }
    }

    // 🔄 تحميل أو إنشاء بيانات اللاعب
    @MainActor
    func loadProgress() {
        if let existing = try? context.fetch(FetchDescriptor<PlayerProgress>()).first {
            playerProgress = existing
        } else {
            let newProgress = PlayerProgress()
            context.insert(newProgress)
            try? context.save()
            playerProgress = newProgress
        }
    }

    // 💾 حفظ التغيرات
    @MainActor
    func save() {
        try? context.save()
    }

    // 💰 إضافة كوينز
    @MainActor
    func addCoins(_ amount: Int) {
        playerProgress?.coins += amount
        save()
    }

    // 💰 خصم كوينز
    @MainActor
    func useCoins(_ amount: Int) -> Bool {
        guard let progress = playerProgress, progress.coins >= amount else { return false }
        progress.coins -= amount
        save()
        return true
    }

    // 🔑 توليد معرف فريد للمرحلة
    func levelKey(trackName: String, levelNumber: Int) -> String {
        return "\(trackName.lowercased())-\(levelNumber)"
    }

    // 📉 تسجيل محاولة فاشلة
    @MainActor
    func registerFailedAttempt(for key: String) {
        guard let progress = playerProgress else { return }

        let current = progress.failedAttempts[key] ?? 0
        progress.failedAttempts[key] = current + 1

        if current + 1 >= 3 {
            progress.lastResetDate = Date()
        }

        save()
    }

    // ⏳ هل يمكن إعادة المحاولة؟
    func canRetry(levelKey: String) -> Bool {
        guard let progress = playerProgress else { return true }

        let attempts = progress.failedAttempts[levelKey] ?? 0

        if attempts < 3 {
            return true
        }

        let hours = Calendar.current.dateComponents([.hour], from: progress.lastResetDate, to: Date()).hour ?? 0
        return hours >= 24
    }

    // 🧼 إعادة المحاولات بعد 24 ساعة
    @MainActor
    func resetFailedAttemptsIfNeeded() {
        guard let progress = playerProgress else { return }

        let now = Date()
        let hours = Calendar.current.dateComponents([.hour], from: progress.lastResetDate, to: now).hour ?? 0

        if hours >= 24 {
            progress.failedAttempts.removeAll()
            progress.lastResetDate = now
            save()
        }
    }

    // 💡 تسجيل استخدام الهنت
    @MainActor
    func useHint(for key: String) -> Bool {
        guard let progress = playerProgress else { return false }

        if !progress.hintsUsed.contains(key) {
            progress.hintsUsed.append(key)
            save()
            return true
        }

        return false
    }

    // ✅ تسجيل المرحلة كمكتملة
    @MainActor
    func markLevelCompleted(_ key: String) {
        guard let progress = playerProgress else { return }
        if !progress.completedLevels.contains(key) {
            progress.completedLevels.append(key)
            save()
        }
    }

    // ⏫ الانتقال للمستوى التالي
    //    @MainActor
    //    func moveToNextLevel(totalLevels: Int) {
    //        guard let progress = playerProgress else { return }
    //
    //        if progress.currentLevelIndex + 1 < totalLevels {
    //            progress.currentLevelIndex += 1
    //        } else {
    //            progress.currentLevelIndex = 0
    //            progress.currentTrackIndex += 1
    //        }
    //
    //        save()
    //    }
    @MainActor
    func moveToNextLevel(totalLevels: Int) {
        guard let progress = playerProgress else { return }

        // 1. التأكد من وجود مسارات
        guard !LevelData.allTracks.isEmpty else { return }

        // 2. البقاء ضمن حدود المسار الحالي
        progress.currentTrackIndex = min(max(progress.currentTrackIndex, 0), LevelData.allTracks.count - 1)

        // 3. الانتقال داخل المسار الحالي
        if progress.currentLevelIndex + 1 < totalLevels {
            progress.currentLevelIndex += 1
        } else {
            // 4. الانتقال لمسار جديد مع الضبط التلقائي
            progress.currentTrackIndex = min(progress.currentTrackIndex + 1, LevelData.allTracks.count - 1)
            progress.currentLevelIndex = 0

            // 5. إذا كنا في آخر مسار، إعادة التعيين
            if progress.currentTrackIndex == LevelData.allTracks.count - 1 {
                progress.currentLevelIndex = min(progress.currentLevelIndex, LevelData.allTracks.last?.levels.count ?? 0)
            }
        }

        // 6. حفظ التغييرات
        save()
    }
    // 🏆 فتح إنجاز جديد
    @MainActor
    func unlockAchievement(_ name: String) {
        guard let progress = playerProgress else { return }
        if !progress.achievementsUnlocked.contains(name) {
            progress.achievementsUnlocked.append(name)
            save()
        }
    }
}
