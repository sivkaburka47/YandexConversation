//
//  APIEndpoint.swift
//  YandexTalk
//
//  Created by Богдан Тарченко on 02.06.2025.
//

import Alamofire

protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
}
