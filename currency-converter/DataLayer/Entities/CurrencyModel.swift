//
//  CurrencyModel.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import Foundation

struct CurrencyModel: Codable {
    let success: Bool
    let terms: String
    let privacy: String
    let timestamp: Int
    let source: String
    let quotes: [String: Double]
    
    var currencies: [String] {
        return quotes.keys.sorted().map { key in
            let range = source.range(of: source)
            let keyStr = String(key)
            return keyStr.replacingOccurrences(of: source, with: "", range: range)
        }
    }
}
