//
//  Requester.swift
//  AirtableKit
//
//  Created by Diego Saragoza Da Silva on 19/05/25.
//

import Foundation

/// Enum indicating the HTTP Method used
public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

/// Enum with all possible cases of HTTP Response from Airtable
public enum HTTPResponse: Int {
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
    
    /// Var with all messages for each case
    public var message: String {
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
            "Route or resource is not found."
        case .requestEntityTooLarge:
            "The request exceeded the maximum allowed payload size."
        case .invalidRequest:
            "The request data is invalid."
        case .tooManyRequests:
            "Rate limit exceeded. Please try again later."
        case .internalServerError:
            "The server encountered an unexpected condition."
        case .badGateway:
            "Airtable's servers are restarting or an unexpected outage is in progress."
        case .serviceUnavailable:
            "The server could not process your request in time. The server could be temporarily unavailable, or it could have timed out processing your request."
        case .unknownResponse:
            "Unknow response."
        }
    }
}

/// The requester for the API
///
/// The requester will be called when doing the CRUD. You can use all the functions in ``AirtableBase``: ``AirtableBase/createRecord(tableName:recordData:)``, ``AirtableBase/queryTable(tableName:)``, ``AirtableBase/updateRecord(tableName:recordData:)`` and ``AirtableBase/deleteRecord(tableName:recordIDs:)``.
public final class Requester {
    
    /// Function that wil send a request to Airtable
    ///
    /// The function used in ``AirtableBase``, to make the CRUD: ``AirtableBase/createRecord(tableName:recordData:)``, ``AirtableBase/queryTable(tableName:)``, ``AirtableBase/updateRecord(tableName:recordData:)`` and ``AirtableBase/deleteRecord(tableName:recordIDs:)``.
    ///
    /// - Parameters:
    ///    - url: the url from the Airtable API with your token.
    ///    - method: the ``HTTPMethod`` that will be used.
    ///    - headers: A dictionary with the key beeing the Airtable Base/Field/Record name and the value being the value related.
    ///    - body: The JSON serialization of the Record Data.
    ///
    /// - returns: A tuple with the Data received from the API and the ``/AirtableKit/HTTPResponse`` from the API.
    ///
    /// - throws: a ``RequestError``: a ``RequestError/failedRequest`` or a ``RequestError/invalidURLString``.
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
