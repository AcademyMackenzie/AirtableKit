//
//  AirtableRecord.swift
//  AirtableKit
//
//  Created by Diego Saragoza Da Silva on 19/05/25.
//

/// The struct that represents a Record from Airtable
public struct AirtableRecord {
    public var id: String
    private var fields: [String : Any]
    
    init(id: String, fields: [String : Any]) {
        self.id = id
        self.fields = fields
    }
    
    /// The function that get a Record Value
    ///
    ///  - Parameter fieldName: The exactly name of the field in Airtable
    ///
    ///  - Returns: A optional generic type of the field response
    public func getRecordValue(fieldName: String) -> Any? {
        return self.fields[fieldName]
    }
    
    /// The function that get a Record Value but as a String
    ///
    ///  - Parameter fieldName: The exactly name of the field in Airtable
    ///
    ///  - Returns: A optional String with the field response
    public func getRecordValueAsString(fieldName: String) -> String? {
        return self.fields[fieldName] as? String
    }
}
