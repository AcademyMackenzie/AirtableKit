// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public class AirtableKit: NSObject {
    nonisolated(unsafe) public static let shared = AirtableKit()
    
    public var apiKey: String = ""
    
    public static func initialize(apiKey: String) {
        self.shared.apiKey = apiKey
    }
}
