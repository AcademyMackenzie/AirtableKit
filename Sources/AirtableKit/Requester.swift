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
    case DELETE = "DELETE"
}

enum HTTPResponse: Int {
    case ok = 200
    case badRequest = 400
    case unauthorized = 401
    case paymentRequired = 402
    case forbbiden = 403
    case notFound = 404
    case requestEntityTooLarge = 413
    case invalidRequest = 422
    case tooManyRequests = 429
    case internalServerError = 500
    case badGateway = 502
    case serviceUnavailable = 503
    case unknownResponse
    
    var message: String {
        switch self {
        case .ok:
            "Request completed successfully."
        case .badRequest:
            "The request encoding is invalid; the request can't be parsed as a valid JSON."
        case .unauthorized:
            "Accessing a protected resource without authorization or with invalid credentials."
        case .paymentRequired:
            "The account associated with the API key making requests hits a quota that can be increased by upgrading the Airtable account plan."
        case .forbbiden:
            "Accessing a protected resource with API credentials that don't have access to that resource."
        case .notFound:
            "Route or resource is not found. This error is returned when the request hits an undefined route, or if the resource doesn't exist (e.g. has been deleted)."
        case .requestEntityTooLarge:
            "The request exceeded the maximum allowed payload size. You shouldn't encounter this under normal use."
        case .invalidRequest:
            "The request data is invalid. This includes most of the base-specific validations. You will receive a detailed error message and code pointing to the exact issue."
        case .tooManyRequests:
            "Rate limit exceeded. Please try again later"
        case .internalServerError:
            "The server encountered an unexpected condition."
        case .badGateway:
            "Airtable's servers are restarting or an unexpected outage is in progress. You should generally not receive this error, and requests are safe to retry."
        case .serviceUnavailable:
            "The server could not process your request in time. The server could be temporarily unavailable, or it could have timed out processing your request. You should retry the request with backoffs."
        case .unknownResponse:
            "Unknow response."
        }
    }
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
