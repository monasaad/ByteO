//
//  Player.swift
//  ByteO
//
//  Created by Shatha Almukhaild on 13/11/1446 AH.
//
import Foundation
import SwiftData

class Player: Identifiable {
    
    var id: UUID
   // To connect the game center with the player
   // could be null to until we make sure we can can connect to game center
    
    // Game center 1-1 relationship with Player
    var gamePlayer_ID: GameCenterPlayer?
    
    /*@Relationship -  Tells SwiftData that this property links to another model.
     
     .cascade delete rule - If this Player is deleted, all related PlayerAchievement records will be automatically deleted too.
     
     inverse:\Playerachievment.player -  it tells swift data that Each PlayerAchievement belongs to one Player.
    */
    @Relationship(deleteRule: .cascade, inverse: \PlayerAchievement.player)
    // Defines the actual relationship: a player has many PlayerAchievement entries.
   var playerAchievements: [PlayerAchievement] = []
   // To store the current user level
   var levelsCompleted: String
    // To store the sum of player score / Points
   var playerScore:Int
    // The Virtual currency that the user use to buy attempts / keys
   var coins: Int
   
    init(id: UUID, gamePlayer_ID: GameCenterPlayer? = nil, playerAchievements: [PlayerAchievement], levelsCompleted: String, playerScore: Int, coins: Int) {
        self.id = id
        self.gamePlayer_ID = gamePlayer_ID
        self.playerAchievements = playerAchievements
        self.levelsCompleted = levelsCompleted
        self.playerScore = playerScore
        self.coins = coins
    }

}
