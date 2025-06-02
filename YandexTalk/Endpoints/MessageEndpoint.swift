//
//  MessageEndpoint.swift
//  YandexTalk
//
//  Created by Станислав Дейнекин on 02.06.2025.
//

import Foundation
import Alamofire

enum MessageEndpoint: APIEndpoint {
    case getPinnedMessages
    case getAllChats
    case getMessages(chatId: UUID)
    case togglePin(messageId: UUID)

    var path: String {
        switch self {
        case .getAllChats:
            return "/Chat"
        case .getMessages(let chatId):
            return "/Message/Chat/\(chatId.uuidString)"
        case .togglePin(let messageId):
            return "/Message/\(messageId.uuidString)/PinUnpin"
        case .getPinnedMessages:
            return "/Message/Pinned"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getAllChats, .getMessages, .getPinnedMessages:
            return .get
        case .togglePin:
            return .patch
        }
    }

    var parameters: Parameters? {
        return nil
    }

    var headers: HTTPHeaders? {
        return nil
    }
}
