//
//  Requester.swift
//  AirtableKit
//
//  Created by Diego Saragoza Da Silva on 19/05/25.
//

import Foundation

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
}

enum HTTPResponse: Int {
    case ok = 200
    case badRequest = 400
    case unauthorized = 401
    case forbbiden = 403
    case notFound = 404
    case requestEntityTooLarge = 413
    case invalidRequest = 422
    case tooManyRequests = 429
    case unknownResponse
}

final class Requester {
    public static func sendRequest(to url: String, method: HTTPMethod, headers: [String : String], body: Data? = nil) async throws -> (Data, HTTPResponse) {
        guard let url: URL = URL(string: url) else {
            throw RequestError.invalidURLString
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        guard let (data, response) = try? await URLSession.shared.data(for: request) else {
            throw RequestError.failedRequest
        }
        
        guard let response = response as? HTTPURLResponse else {
            throw RequestError.failedRequest
        }
        
        return (data, HTTPResponse(rawValue: response.statusCode) ?? .unknownResponse)
    }
}
