//
//  CurrencyInteractorOutputMock.swift
//  currency-converterTests
//
//  Created by Wai Phyo on 8/8/21.
//

import Foundation
@testable import currency_converter

class CurrencyInteractorOutputMock: CurrencyInteractorOutputProtocol {
    
    //  MARK: Mock variables.
    private(set) var data = [String: Double]()
    private(set) var originalData = [CurrencyLocalModel]()
    private(set) var deletions = [Int]()
    private(set) var insertions = [Int]()
    private(set) var modifications = [Int]()
    
    private(set) var isFinishedLiveCurrenciesCall = false
    
    func changedCurrencyRates(with data: [String : Double], originalData: [CurrencyLocalModel], deletions: [Int], insertions: [Int], modifications: [Int]) {
        self.data = data
        self.originalData = originalData
        self.deletions = deletions
        self.insertions = insertions
        self.modifications = modifications
    }
    
    func finishedLiveCurrenciesCall() {
        isFinishedLiveCurrenciesCall = true
    }
}
