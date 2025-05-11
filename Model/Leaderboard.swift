//
//  Leaderboard.swift
//  ByteO
//
//  Created by Shatha Almukhaild on 13/11/1446 AH.
//

import Foundation
import SwiftData
struct Leaderboard : Identifiable {
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
