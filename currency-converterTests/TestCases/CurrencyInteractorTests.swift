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
        XCTAssertTrue(interactor?.areRatesSavedLocally ?? false)
    }
    
    func testNoInternetErrorHandling() {
        webServiceMock.apiCallState = .fail(error: .nointernet)
        interactor?.getLiveCurrencies()
        XCTAssertTrue(presenterMock.error == .nointernet)
    }
    
    func testNoTimeoutErrorHandling() {
        webServiceMock.apiCallState = .fail(error: .timeout)
        interactor?.getLiveCurrencies()
        XCTAssertTrue(presenterMock.error == .timeout)
    }
    
    func testHttpErrorHandling() {
        webServiceMock.apiCallState = .fail(error: .httperror(status: 500, msg: nil))
        interactor?.getLiveCurrencies()
        XCTAssertTrue(presenterMock.error == .httperror(status: 500, msg: nil))
    }
    
    func testUnknownErrorHandle() {
        webServiceMock.apiCallState = .fail(error: .unknown)
        interactor?.getLiveCurrencies()
        XCTAssertTrue(presenterMock.error == .unknown)
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
