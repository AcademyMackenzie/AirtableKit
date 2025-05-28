//
//  AirtableTable.swift
//  AirtableKit
//
//  Created by Diego Saragoza Da Silva on 19/05/25.
//

import Foundation

/// Struct that represents a Table from Airtable
public struct AirtableTable: Codable {
    
    /// The Table id from Airtable
    public var id: String
    
    /// The Table name from Airtable
    public var name: String
    
    /// All the ``/AirtableKit/AirtableField`` the Table have
    public var fields: [AirtableField]
}
