//
//  HTTPClient.swift
//  YandexTalk
//
//  Created by Богдан Тарченко on 02.06.2025.
//

protocol HTTPClient {
    func sendRequest<T: Decodable, U: Encodable>(endpoint: APIEndpoint, requestBody: U?) async throws -> T
    func sendRequestWithoutResponse<U: Encodable>(endpoint: APIEndpoint, requestBody: U?) async throws
}
