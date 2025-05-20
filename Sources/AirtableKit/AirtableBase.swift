//
//  AirtableBase.swift
//  AirtableKit
//
//  Created by Diego Saragoza Da Silva on 19/05/25.
//

import Foundation

struct AirtableBase {
    public var baseID: String
    public var tables: [AirtableTable]
    
    init(baseID: String) async {
        self.baseID = baseID
        self.tables = []
        
        guard let (requestData, requestResponse) = try? await Requester.sendRequest(
            to: "https://api.airtable.com/v0/meta/bases/\(self.baseID)/tables",
            method: .GET,
            headers: ["Authorization": "Bearer \(AirtableKit.shared.apiKey)"]
        ) else {
            print("Not able to get base tables")
            return
        }
        
        if requestResponse != HTTPResponse.ok {
            print(requestResponse)
        }
        
        guard let jsonData = try? JSONSerialization.jsonObject(with: requestData, options: []) as? [String: Any] else {
            print("Not able to parse request data")
            return
        }
        self.getTableDataFromJSON(from: jsonData)
    }
    
    public func queryTable(tableName: String) async -> [AirtableRecord] {
        guard let (requestData, requestResponse) = try? await Requester.sendRequest(
            to: "https://api.airtable.com/v0/\(self.baseID)/\(tableName)",
            method: HTTPMethod.GET,
            headers: ["Authorization": "Bearer \(AirtableKit.shared.apiKey)"]
        ) else {
            print("Not able to query for table records")
            return []
        }
        
        if requestResponse != HTTPResponse.ok {
            print(requestResponse)
        }
        
        guard let jsonData = try? JSONSerialization.jsonObject(with: requestData, options: []) as? [String: Any] else {
            print("Not able to parse request data")
            return []
        }
        
        return self.getRecordDataFromJSON(from: jsonData)
    }
    
    public func createRecord(tableName: String, recordData: [[String : Any]]) async {
        let _recordData: [String : Any] = [
            "records": recordData
        ]
        let jsonBody = try? JSONSerialization.data(withJSONObject: _recordData)
        
        guard let (requestData, requestResponse) = try? await Requester.sendRequest(
            to: "https://api.airtable.com/v0/\(self.baseID)/\(tableName)",
            method: HTTPMethod.POST,
            headers: [
                "Authorization": "Bearer \(AirtableKit.shared.apiKey)",
                "Content-Type": "application/json"
            ],
            body: jsonBody
        ) else {
            print("Not able to query for table records")
            return
        }
        
        if requestResponse != HTTPResponse.ok {
            print(requestResponse)
        }
    }
    
    public func updateRecord(tableName: String, recordData: [[String : Any]]) async {
        await self.createRecord(tableName: tableName, recordData: recordData)
    }
    
    public func deleteRecord(tableName: String, recordIDs: [String]) async {
        var requestURL: String = "https://api.airtable.com/v0/\(self.baseID)/\(tableName)?"
        for i in 0..<recordIDs.count {
            if i < recordIDs.count - 1 {
                requestURL += "records[]=\(recordIDs[i])&"
            }
            else {
                requestURL += "records[]=\(recordIDs[i])"
            }
        }

        guard let (_, requestResponse) = try? await Requester.sendRequest(
            to: requestURL,
            method: HTTPMethod.DELETE,
            headers: ["Authorization": "Bearer \(AirtableKit.shared.apiKey)"]
        ) else {
            print("Not able to delete record from table")
            return
        }
        
        if requestResponse != HTTPResponse.ok {
            print(requestResponse)
        }
    }
    
    private mutating func getTableDataFromJSON(from json: [String : Any]) {
        guard let _tables = json["tables"] as? [[String : Any]] else {
            print("Unable to parse JSON data from response")
            return
        }

        for table in _tables {
            let tableID = table["id"] as? String ?? "Failed to Parse"
            let tableName = table["name"] as? String ?? "Failed to Parse"
            
            var tableFields: [AirtableField] = []
            guard let _fields = table["fields"] as? [[String : Any]] else {
                print("Unable to parse fields from JSON data")
                return
            }
            for field in _fields {
                let fieldID = field["id"] as? String ?? "Failed to Parse"
                let fieldName = field["name"] as? String ?? "Failed to Parse"
                tableFields.append(AirtableField(
                    id: fieldID,
                    name: fieldName
                ))
            }
            
            self.tables.append(AirtableTable(
                id: tableID,
                name: tableName,
                fields: tableFields
            ))
        }
    }
    
    private func getRecordDataFromJSON(from json: [String : Any]) -> [AirtableRecord] {
        guard let _records = json["records"] as? [[String : Any]] else {
            print("Unable to parse JSON data from response")
            return []
        }
        
        var records: [AirtableRecord] = []
        for record in _records {
            let recordID: String = record["id"] as? String ?? "Unable to Parse"
            let recordFields: [String : Any] = record["fields"] as? [String : Any] ?? [:]
            
            records.append(AirtableRecord(
                id: recordID,
                fields: recordFields
            ))
        }
        
        return records
    }
}
