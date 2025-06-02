//
//  AlamofireHTTPClient.swift
//  YandexTalk
//
//  Created by Богдан Тарченко on 02.06.2025.
//

import Alamofire
import Foundation

final class AlamofireHTTPClient: HTTPClient {
    
    private let baseURL = "http://localhost:5036/api"

    func sendRequest<T: Decodable, U: Encodable>(endpoint: APIEndpoint, requestBody: U? = nil) async throws -> T {
        let url = baseURL + endpoint.path
        let method = endpoint.method
        let headers = endpoint.headers
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: method, parameters: requestBody, encoder: JSONParameterEncoder.default, headers: headers)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let decodedData):
                        continuation.resume(returning: decodedData)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    func sendRequestWithoutResponse<U: Encodable>(endpoint: APIEndpoint, requestBody: U? = nil) async throws {
        let url = baseURL + endpoint.path
        let method = endpoint.method
        let headers = endpoint.headers
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: method, parameters: requestBody, encoder: JSONParameterEncoder.default, headers: headers)
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        continuation.resume()
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
