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
