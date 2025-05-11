//
//  GameCenterPlayer.swift
//  ByteO
//
//  Created by Shatha Almukhaild on 13/11/1446 AH.
//

import Foundation
import SwiftData
@Model
class GameCenterPlayer {
    var gamePlayer_ID: String
    var alias: String
    var displayName: String
    var isUnderage: Bool
    
    init(gamePlayer_ID: String, alias: String, displayName: String, isUnderage: Bool) {
        self.gamePlayer_ID = gamePlayer_ID
        self.alias = alias
        self.displayName = displayName
        self.isUnderage = isUnderage
    }
}
