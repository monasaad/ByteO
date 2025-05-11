//
//  Settings.swift
//  ByteO
//
//  Created by Shatha Almukhaild on 13/11/1446 AH.
//

import Foundation
import SwiftData
class Setting: Identifiable {
    var id : UUID
    // to track weather the user turn on/off music or not
    var soundMuted : Bool
    init(id: UUID, soundMuted: Bool) {
        self.id = id
        self.soundMuted = soundMuted
    }
}
