//
//  Message.swift
//  YandexTalk
//
//  Created by Станислав Дейнекин on 02.06.2025.
//

import Foundation

struct Message: Identifiable, Codable {
    let id: UUID
    let text: String
    let createTime: Date
    let isPinned: Bool

    enum CodingKeys: String, CodingKey {
        case id = "messageId"
        case text
        case createTime
        case isPinned
    }
}
