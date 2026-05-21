//
//  Array+Utils.swift
//  AirtableKit
//
//  Created by Diego Saragoza Da Silva on 21/05/26.
//

import Foundation

extension Array {
    // Batch the array into smaller chunks with size "into".
    // If the array count is not multiple of size, the final array will contain the remainder items
    func batched(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
