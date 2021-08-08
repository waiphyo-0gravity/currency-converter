//
//  MockData.swift
//  currency-converterTests
//
//  Created by Wai Phyo on 8/8/21.
//

import Foundation
@testable import currency_converter

struct MockData {
    var rates: [String: Double] = [
        "USD": 1.00,
        "MMK": 1600.00,
        "JEP": 0.72276
    ]
    
    var successApiRateData: CurrencyModel = CurrencyModel(
        success: true,
        terms: "",
        privacy: "",
        timestamp: 1628423584,
        source: "USD",
        quotes: [
            "USDUSD": 1,
            "USDMMK": 1651.863247,
            "USDJEP": 0.722761
        ],
        error: nil
    )
    
    var failedApiRateData: CurrencyModel = CurrencyModel(
        success: false,
        terms: nil,
        privacy: nil,
        timestamp: nil,
        source: nil,
        quotes: nil,
        error: .init(code: 101, type: "", info: "")
    )
    
    var localRatesData: [CurrencyLocalModel] = [
        CurrencyLocalModel.createModel(code: "USD", rate: 1.00),
        CurrencyLocalModel.createModel(code: "MMK", rate: 1600.00),
        CurrencyLocalModel.createModel(code: "JEP", rate: 0.72276)
    ]
    
    var currencyCodes: [String] {
        return localRatesData.map { $0.code }
    }
}
