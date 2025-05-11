//
//  Achievement.swift
//  ByteO
//
//  Created by Shatha Almukhaild on 13/11/1446 AH.
//

import Foundation
import CoreGraphics
import SwiftData
@Model
class Achievement : Identifiable {
    var id: UUID
    /*@Relationship -  Tells SwiftData that this property links to another model.
     
     .cascade delete rule - If this Achievement is deleted, all related PlayerAchievement records will be automatically deleted too.
     
     inverse:\Playerachievment.achievement -  it tells swift data that Each PlayerAchievement belongs to one Achievement.
    */
    @Relationship(deleteRule: .cascade, inverse: \PlayerAchievement.achievement)
    // Defines the actual relationship: an Achievement has many PlayerAchievement entries.
       var playerAchievements: [PlayerAchievement] = []
    // 1-1 relationship with level
    var level: Level?
    // the icon on the game center achievement
    var iconImage: CGImage?
    // title of the levels
    var title : String
    // description of the level
    var AchievementDescription : String
    // to assign points to each level
    var points : Int
    // to track the level/achievement statues locked/unlocked
    var isLocked : Bool
    
    
  init(id: UUID = UUID(), level: Level? = nil, iconImage: CGImage? = nil, title: String, description: String, points: Int, isLocked: Bool) {
        self.id = id
        self.level = level
        self.iconImage = iconImage
        self.title = title
        self.AchievementDescription = description
        self.points = points
        self.isLocked = isLocked
    }
}
