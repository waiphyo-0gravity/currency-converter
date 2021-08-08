//
//  CurrencyWebServiceInputMock.swift
//  currency-converterTests
//
//  Created by Wai Phyo on 8/8/21.
//

import Foundation
@testable import currency_converter

class CurrencyWebServiceInputMock: CurrencyWebServiceInputProtocol {
    var interactor: CurrencyWebServiceOutputProtocol?
    
    //  MARK: - Mock variables.
    var isSuccessCall = true
    let mockData = MockData()
    
    func callLiveCurrencies() {
        interactor?.gotLiveCurrencies(success: isSuccessCall, data: isSuccessCall ? mockData.successApiRateData : mockData.failedApiRateData, error: nil, status: isSuccessCall ? 200 : 500)
    }
}
