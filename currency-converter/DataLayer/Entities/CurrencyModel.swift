//
//  CurrencyModel.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import Foundation

struct CurrencyModel: Codable {
    let success: Bool
    let terms: String?
    let privacy: String?
    let timestamp: Int?
    let source: String?
    let quotes: [String: Double]?
    let error: Error?
    
    var currencies: [String] {
        guard let source = source else { return [] }
        
        return quotes?.keys.sorted().map { key in
            let range = source.range(of: source)
            let keyStr = String(key)
            return keyStr.replacingOccurrences(of: source, with: "", range: range)
        } ?? []
    }
    
    struct Error: Codable {
        let code: Int?
        let type: String?
        let info: String?
    }
}
