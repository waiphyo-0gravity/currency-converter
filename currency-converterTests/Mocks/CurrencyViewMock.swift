//
//  CurrencyViewMock.swift
//  currency-converterTests
//
//  Created by Wai Phyo on 8/8/21.
//

import Foundation
@testable import currency_converter

class CurrencyViewMock: CurrencyViewProtocol {
    var presenter: CurrencyPresenterProtocol?
    
    private(set) var isEndRefreshControl = false
    private(set) var updateIndexs: (deletions: [Int], insertions: [Int], modifications: [Int]) = ([], [] , [])
    private(set) var isSourceCurrencyUpdate = false
    private(set) var loadingState = false
    private(set) var error: CurrencyError?
    
    func updateCurrencyList(deletions: [Int], insertions: [Int], modifications: [Int]) {
        updateIndexs = (deletions, insertions, modifications)
    }
    
    func endRefreshControl() {
        isEndRefreshControl = true
    }
    
    func updateSourceCurrencyUIs(isAnimate: Bool) {
        isSourceCurrencyUpdate = true
    }
    
    func changeLoadingState(isLoading: Bool, isAnimate: Bool) {
        loadingState = isLoading
    }
    
    func gotError(error: CurrencyError) {
        self.error = error
    }
}
