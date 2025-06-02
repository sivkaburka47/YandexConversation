//
//  MessageEndpoint.swift
//  YandexTalk
//
//  Created by Станислав Дейнекин on 02.06.2025.
//

import Alamofire

enum MessageEndpoint: APIEndpoint {
    case getPinnedMessages

    var path: String {
        switch self {
        case .getPinnedMessages:
            return "/Message/Pinned"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getPinnedMessages:
            return .get
        }
    }

    var parameters: Parameters? {
        return nil
    }

    var headers: HTTPHeaders? {
        return nil
    }
}
