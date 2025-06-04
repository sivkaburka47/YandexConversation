//
//  Chat.swift
//  YandexTalk
//
//  Created by Станислав Дейнекин on 02.06.2025.
//

import Foundation

struct Chat: Identifiable, Codable {
    let id: UUID
    let createTime: Date
    let lastMessage: Message?

    enum CodingKeys: String, CodingKey {
        case id
        case createTime
        case lastMessage
    }
}
