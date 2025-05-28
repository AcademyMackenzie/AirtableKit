// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

/// The Object initialized in app to use AirtableKit
public class AirtableKit: NSObject {
    /// Creating a singleton to have one instance of Airtable api Key
    nonisolated(unsafe) public static let shared = AirtableKit()
    
    /// The user apiKey from airtable
    public var apiKey: String = ""
    
    /// Function used to initialize the AirtableKit
    ///
    ///  - Parameters:
    ///     - apiKey: The user apiKey from airtable
    public static func initialize(apiKey: String) {
        self.shared.apiKey = apiKey
    }
}
