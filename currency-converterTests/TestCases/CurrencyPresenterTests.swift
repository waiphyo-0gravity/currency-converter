//
//  CurrencyPresenterTests.swift
//  currency-converterTests
//
//  Created by Wai Phyo on 8/8/21.
//

import XCTest
@testable import currency_converter

class CurrencyPresenterTests: XCTestCase {
    private var presenter: CurrencyPresenterProtocol?
    
    private let viewMock = CurrencyViewMock()
    private let interactorMock = CurrencyInteractorInputMock()
    
    override func setUp() {
        super.setUp()
        presenter = createPresenter()
    }
    
    override func tearDown() {
        presenter = nil
        super.tearDown()
    }
    
    func testRefreshingRatesInViewDidLoad() {
        presenter?.viewDidLoad()
        XCTAssertEqual(presenter?.displayCurrencies, interactorMock.mockData.currencyCodes)    
    }
    
    func testPullDownRefresh() {
        presenter?.refreshLiveCurrencies()
        XCTAssertEqual(presenter?.displayCurrencies, interactorMock.mockData.currencyCodes)
    }
    
//  MKAR: Test exchange rate from 2USD to MMK
    func testCurrencyExchangeRate() {
        let fromCurrencyCode = "USD"
        let toCurrencyCode = "MMK"
        
        presenter?.refreshLiveCurrencies()
        presenter?.changeSourceValue(to: 2)
        interactorMock.choosedCurrency = fromCurrencyCode
        
        let data = presenter?.getCurrencyDisplayData(for: toCurrencyCode)
        
        XCTAssertEqual(data?.currencyCode, "MMK")
        XCTAssertEqual(data?.currencyName, "Myanmar Kyat")
        XCTAssertEqual(data?.exchangeRateStr, "MMK 3,200.00")
    }
    
    func testGettingDataForSourceCurrency() {
        interactorMock.choosedCurrency = "USD"
        let data = presenter?.getSourceCurrencyDisplayData()
        
        XCTAssertEqual(data?.currencyCode, "USD")
        XCTAssertEqual(data?.currencyName, "US Dollar")
        XCTAssertEqual(data?.currencySymbol, "$")
    }
    
    func testChangingSourceCurrency() {
        let changedSource = "MMK"
        presenter?.changeSourceCurrency(with: changedSource)
        
        XCTAssertEqual(interactorMock.choosedCurrency, changedSource)
    }
    
    func testChangingSourceValue() {
        let value: Double = 10000
        presenter?.changeSourceValue(to: value)
        
        XCTAssertEqual(presenter?.sourceValue, value)
    }
}

//  MARK: - Private functions.
extension CurrencyPresenterTests {
    private func createPresenter() -> CurrencyPresenterProtocol {
        let currencyPresenter =  CurrencyPresenter()
        
        currencyPresenter.view = viewMock
        currencyPresenter.interactor = interactorMock
        interactorMock.presenter = currencyPresenter
        
        return currencyPresenter
    }
}
