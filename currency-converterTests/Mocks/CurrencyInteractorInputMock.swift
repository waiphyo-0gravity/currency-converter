//
//  CurrencyInteractorInputMock.swift
//  currency-converterTests
//
//  Created by Wai Phyo on 8/8/21.
//

import Foundation
@testable import currency_converter

class CurrencyInteractorInputMock: CurrencyInteractorInputProtocol {
    var presenter: CurrencyInteractorOutputProtocol?
    
    var localStorage: CurrencyLocalStorageProtocol?
    
    var webService: CurrencyWebServiceInputProtocol?
    
    var choosedCurrency: String?
    
    var areRatesSavedLocally: Bool?
    
    let mockData = MockData()
    
    func getLiveCurrencies() {
        presenter?.changedCurrencyRates(with: mockData.rates, originalData: mockData.localRatesData, deletions: [], insertions: [0, 1, 2], modifications: [])
    }
}
