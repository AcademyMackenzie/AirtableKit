//
//  AirtableRecord.swift
//  AirtableKit
//
//  Created by Diego Saragoza Da Silva on 19/05/25.
//

struct AirtableRecord {
    public var id: String
    private var fields: [String : Any]
    
    init(id: String, fields: [String : Any]) {
        self.id = id
        self.fields = fields
    }
    
    public func getRecordValue(fieldName: String) -> Any? {
        return self.fields[fieldName]
    }
    
    public func getRecordValueAsString(fieldName: String) -> String? {
        return self.fields[fieldName] as? String
    }
}
