//
//  Phrase.swift
//  YandexTalk
//
//  Created by Станислав Дейнекин on 02.06.2025.
//

import Foundation

struct Phrase: Identifiable, Equatable {
    let id: String
    var text: String
    var timestamp: Date
    var isPinned: Bool
}

extension Phrase {
    init(from pinnedMessage: PinnedMessage) {
        self.id = pinnedMessage.id.uuidString
        self.text = pinnedMessage.text
        self.timestamp = Date()
        self.isPinned = true
    }
}

