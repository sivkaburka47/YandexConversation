//
//  ChatMessage.swift
//  YandexTalk
//
//  Created by Станислав Дейнекин on 01.06.2025.
//

import Foundation

struct ChatMessage: Identifiable, Hashable {
    let id = UUID()
    let sender: Sender
    let text: String
    let timestamp: Date

    enum Sender: Hashable {
        case me
        case other

        var displayName: String {
            switch self {
            case .me: return "Вы"
            case .other: return "Говорящий"
            }
        }

        var isMe: Bool {
            self == .me
        }
    }
}
