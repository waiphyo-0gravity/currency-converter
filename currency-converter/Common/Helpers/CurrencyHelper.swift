//
//  CurrencyMapper.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import Foundation

class CurrencyHelper {
    static let instance: CurrencyHelper = {
        return CurrencyHelper()
    }()
    
    func getCurrencySymbol(forCurrencyCode currencyCode: String) -> String {
        return Locale.current.localizedCurrencySymbol(forCurrencyCode: currencyCode) ?? currencyCode
    }
    
    func getCurrencyName(forCurrencyCode currencyCode: String) -> String {
        return Locale.current.localizedString(forCurrencyCode: currencyCode) ?? currencyCode
    }
    
    func changeFormat(for value: Double, currencyCode: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 5
        formatter.currencyCode = currencyCode
        
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
    
    func trimSourceCurrencyCode(for code: String, source: String) -> String {
        let range = source.range(of: source)
        return code.replacingOccurrences(of: source, with: "", range: range)
    }
}
