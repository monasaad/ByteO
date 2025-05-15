////
////  Settings.swift
////  ByteO
////
////  Created by Shatha Almukhaild on 13/11/1446 AH.
////
//
import Foundation
import SwiftData
import CoreGraphics
import SwiftUI

// Settings.swift - Updated for SwiftUI compatibility
@Model
class Settings {
     var id: UUID
     var soundMuted: Bool

    init(id: UUID = UUID(), soundMuted: Bool = false) {
        self.id = id
        self.soundMuted = soundMuted
    }
}

//// Player.swift - Updated for SwiftUI compatibility
@Model
class Player {
     var id: UUID
     var gamePlayer_ID: GameCenterPlayer?
     var playerAchievements: [PlayerAchievement] = []
     var levelsCompleted: String
     var playerScore: Int
     var coins: Int
     var attempts: Int
    
    init(id: UUID = UUID(), gamePlayer_ID: GameCenterPlayer? = nil, playerAchievements: [PlayerAchievement] = [], levelsCompleted: String = "", playerScore: Int = 0, coins: Int = 1000, attempts: Int = 3 ) {
        self.id = id
        self.gamePlayer_ID = gamePlayer_ID
        self.playerAchievements = playerAchievements
        self.levelsCompleted = levelsCompleted
        self.playerScore = playerScore
        self.coins = coins
        self.attempts = attempts
    }
}



/// يمثل مستوى واحد: رقمه، أسئلته، وحالته المكتملة
//@Model
//class Level: Identifiable {
//    var id: Int                  // رقم المستوى
//    var questions: [Question]
//    var isCompleted: Bool = false
//
//    init(id: Int, questions: [Question], isCompleted: Bool = false) {
//        self.id = id
//        self.questions = questions
//        self.isCompleted = isCompleted
//       
//    }
//}

@Model
class Level: Identifiable {
  var id: Int
  var isCompleted: Bool

  init(id: Int, isCompleted: Bool = false) {
    self.id = id
    self.isCompleted = isCompleted
  }
}
struct Question: Identifiable {
    let id = UUID()
    let questionText: String
    let correctAnswer: String
    let key: String
    let hint: String
    var hintUsesAllowed: Int
    var hintUsed: Int = 0
}

final class QuestionBank {
    static let shared = QuestionBank()

    // خريطة الأسئلة حسب رقم المستوى
    let questionsByLevel: [Int: [Question]] = [
        1: [
            Question(
                questionText: "Decrypt the message",
                correctAnswer: "AAAAA",
                key: "2",
                hint: "Shift letters backward by 3",
                hintUsesAllowed: 2
            )
        ],
        2: [
            Question(
                questionText: "Find the secret",
                correctAnswer: "BAAAA",
                key: "2",
                hint: "Use key 5 for each letter",
                hintUsesAllowed: 2
            )
        ],
        3: [
            Question(
                questionText: "Find the secret",
                correctAnswer: "CAAAA",
                key: "2",
                hint: "Use key 5 for each letter",
                hintUsesAllowed: 2
            )
        ]
        // يمكنك إضافة مستويات جديدة هنا
    ]

    private init() {}
}



// Achievement.swift - Updated for SwiftUI compatibility
@Model
class Achievement {
    var id: UUID
    var playerAchievements: [PlayerAchievement] = []
    var level: Level?
    var title: String
    var achievementDescription: String
    var points: Int
    var isLocked: Bool

    // ✅ تعريف حالة فتح الإنجاز
    var isUnlocked: Bool {
        return !isLocked
    }
    
    init(id: UUID = UUID(), level: Level? = nil, title: String = "Achievement",
         achievementDescription: String = "", points: Int = 0, isLocked: Bool = true) {
        self.id = id
        self.level = level
        self.title = title
        self.achievementDescription = achievementDescription
        self.points = points
        self.isLocked = isLocked
    }
}


// PlayerAchievement.swift - Updated for SwiftUI compatibility
@Model
class PlayerAchievement{
     var id: UUID
     var achievement: Achievement
     var player: Player

    init(id: UUID = UUID(), achievement: Achievement, player: Player) {
        self.id = id
        self.achievement = achievement
        self.player = player
    }
}

@Model
class Leaderboard  {
     var id = UUID()
     var player:Player?
    // to track user rank among other players
     var rank : Int
    
    init(id: UUID = UUID(), player: Player? = nil, rank: Int) {
        self.id = id
        self.player = player
        self.rank = rank
    }
}

@Model
class GameCenterPlayer {
   var id: UUID
   var gamePlayer_ID: String
   var alias: String
   var displayName: String
   var isUnderage: Bool

    init(gamePlayer_ID: String = "unknown_id", alias: String = "Guest", displayName: String = "Player", isUnderage: Bool = false) {
        self.id = UUID()
        self.gamePlayer_ID = gamePlayer_ID
        self.alias = alias
        self.displayName = displayName
        self.isUnderage = isUnderage
    }
}

//// GameDataStore.swift




@Model
 class GameDataStore {
  // علشان تكون instance وحيدة محفوظة
  var id: UUID

  // العلاقات (عكس One–to–Many)
  var player: Player
  var settings: Settings
  var achievements: [Achievement]
  var levels: [Level]

  var currentLevel: Int

  init(
    id: UUID = UUID(),
    player: Player,
    settings: Settings,
    achievements: [Achievement] = [],
    levels: [Level],
    currentLevel: Int = 1
  ) {
    self.id = id
    self.player = player
    self.settings = settings
    self.achievements = achievements
    self.levels = levels
    self.currentLevel = currentLevel
  }
}
