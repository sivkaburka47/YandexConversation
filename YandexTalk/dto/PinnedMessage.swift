//
//  PinnedMessage.swift
//  YandexTalk
//
//  Created by Станислав Дейнекин on 02.06.2025.
//

import Foundation

struct PinnedMessage: Identifiable, Codable, Equatable {
    let id: UUID
    let text: String

    enum CodingKeys: String, CodingKey {
        case id = "messageId"
        case text
    }
}
