//
//  AirtableTable.swift
//  AirtableKit
//
//  Created by Diego Saragoza Da Silva on 19/05/25.
//

import Foundation

struct AirtableTable: Codable {
    public var id: String
    public var name: String
    public var fields: [AirtableField]
}
