//
//  Level.swift
//  ByteO
//
//  Created by Shatha Almukhaild on 13/11/1446 AH.
//

import Foundation
import SwiftData

class Level: Identifiable {
    var id: UUID
    // to store the correct answer
    var question: String
    // to compare the user answer with the correct answer
    var correctAnswer: String
    // to store the key / attempts that the user have
    var key: String
    // to track how many hints user used
    var hintUsed:Int
    
    
    init(id: UUID = UUID(), question: String, correctAnswer: String, key: String, hintUsed: Int) {
        self.id = id
        self.question = question
        self.correctAnswer = correctAnswer
        self.key = key
        self.hintUsed = hintUsed
    }
}
