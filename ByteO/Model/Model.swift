////
////  Model.swift
////  testgame
////
////  Created by atheer alshareef on 15/05/2025.
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
    var hasSeenIntro: Bool // جديد 👇

    init(id: UUID = UUID(), soundMuted: Bool = false, hasSeenIntro: Bool = false) {
        self.id = id
        self.soundMuted = soundMuted
        self.hasSeenIntro = hasSeenIntro
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
    var lastAttemptsReset: Date?
    
    init(id: UUID = UUID(), gamePlayer_ID: GameCenterPlayer? = nil, playerAchievements: [PlayerAchievement] = [],levelsCompleted: String = "", playerScore: Int = 0,coins: Int = 1000,attempts: Int = 3,lastAttemptsReset: Date? = nil)
    {
        self.id = id
        self.gamePlayer_ID = gamePlayer_ID
        self.playerAchievements = playerAchievements
        self.levelsCompleted = levelsCompleted
        self.playerScore = playerScore
        self.coins = coins
        self.attempts = attempts
        self.lastAttemptsReset = lastAttemptsReset // ✅ أضف هذا
    }
}



@Model
class Level: Identifiable {
  var id: Int
  //let levelNumber: Int
    
  var isCompleted: Bool
  //  var questions: [Question]
  init(id: Int, isCompleted: Bool = false) //, questions: [Question]
    {
    self.id = id
    self.isCompleted = isCompleted
    //self.questions = questions
  }
}

@Model
class Question: Identifiable {
    var id: UUID
    var questionText: String
    var correctAnswer: String
    var key: String
    var hint: String
    var hintUsesAllowed: Int
    var hintUsed: Int

    init(questionText: String, correctAnswer: String, key: String, hint: String, hintUsesAllowed: Int, hintUsed: Int = 0) {
        self.id = UUID()
        self.questionText = questionText
        self.correctAnswer = correctAnswer
        self.key = key
        self.hint = hint
        self.hintUsesAllowed = hintUsesAllowed
        self.hintUsed = hintUsed
    }
}


//// MARK: - Question Model
//struct Question {
//    let id: Int
//    let questionText: String
//    let encryptedText: String
//    let key: Int
//    let answers: [String]
//    let correctAnswer: String
//    let hint: Hint
//}
//// MARK: - Hint Model
//struct Hint {
//    let hintText: String
//    let isUsed: Bool
//    let requiresAd: Bool
//}
//



final class QuestionBank {
    static let shared = QuestionBank()

    // خريطة الأسئلة حسب رقم المستوى
    let questionsByLevel: [Int: [Question]] = [
        1: [
            Question(
                questionText: "Decrypt the message",
                correctAnswer: "AAAAA",
                key: "3",
                hint: "Shift letters backward by 3",
                hintUsesAllowed: 1
            )
        ],
        2: [
            Question(
                questionText: "Find the secret",
                correctAnswer: "BAAAA",
                key: "5",
                hint: "Use key 5 for each letter",
                hintUsesAllowed: 1
            )
        ],
        3: [
            Question(
                questionText: "Find the secret 3",
                correctAnswer: "CAAAA",
                key: "2",
                hint: "Use key 6 for each letter",
                hintUsesAllowed: 1
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
