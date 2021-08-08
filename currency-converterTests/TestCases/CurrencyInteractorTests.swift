//
//  CurrencyInteractorTests.swift
//  currency-converterTests
//
//  Created by Wai Phyo on 8/8/21.
//

import XCTest
@testable import currency_converter

class CurrencyInteractorTests: XCTestCase {
    private var interactor: CurrencyInteractorInputProtocol?
    
    private let presenterMock = CurrencyInteractorOutputMock()
    private let localStorageMock = CurrencyLocalStorageMock()
    private let webServiceMock = CurrencyWebServiceInputMock()
    
    override func setUp() {
        super.setUp()
        interactor = createInteractor()
    }
    
    override func tearDown() {
        interactor = nil
        super.tearDown()
    }
    
    func testGettingLiveCurrencyRate() {
        interactor?.getLiveCurrencies()
        print(<#T##items: Any...##Any#>)
        XCTAssertTrue(interactor?.areRatesSavedLocally ?? false)
    }
}

//  MARK: - Private functions.
extension CurrencyInteractorTests {
    private func createInteractor() -> CurrencyInteractorInputProtocol {
        let currencyInteractor = CurrencyInteractor()
        let localStorageMock = CurrencyLocalStorageMock()
        
        currencyInteractor.presenter = presenterMock
        currencyInteractor.webService = webServiceMock
        webServiceMock.interactor = currencyInteractor
        currencyInteractor.localStorage = localStorageMock
        
        return currencyInteractor
    }
}
