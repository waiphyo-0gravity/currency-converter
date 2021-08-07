//
//  Locale+Extensions.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import Foundation

extension Locale {
    func localizedCurrencySymbol(forCurrencyCode currencyCode: String) -> String? {
        guard let languageCode = languageCode, let regionCode = regionCode else { return nil }
        
        let components: [String: String] = [
            NSLocale.Key.languageCode.rawValue: languageCode,
            NSLocale.Key.countryCode.rawValue: regionCode,
            NSLocale.Key.currencyCode.rawValue: currencyCode,
        ]

        let identifier = Locale.identifier(fromComponents: components)

        return Locale(identifier: identifier).currencySymbol
    }
}
