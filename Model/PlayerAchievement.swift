//
//  PlayerAchievement.swift
//  ByteO
//
//  Created by Shatha Almukhaild on 13/11/1446 AH.
//


import Foundation
import SwiftData
// joined table as the relationship between Player and Achievement Many-Many
@Model
class PlayerAchievement: Identifiable {

    var id: UUID
    
    // 1-1 relationship with achievement
    var achievement: Achievement
    
    // 1-1 relationship with player
    var player: Player
    
    init(id: UUID, achievement: Achievement, player: Player) {
        self.id = id
        self.achievement = achievement
        self.player = player
    }
}
