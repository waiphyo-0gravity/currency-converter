//
//  CurrencyPresenter.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import Foundation

class CurrencyPresenter: CurrencyPresenterProtocol {
    weak var view: CurrencyViewProtocol?
    var interactor: CurrencyInteractorInputProtocol?
    var router: CurrencyRouterProtocol?
    private(set)var displayCurrencies = [String]()
    
    //  MARK: Private variables
    private var currencyRates = [String: Double]()
    
    func viewDidLoad() {
        view?.updateSourceCurrencyUIs()
//        interactor?.getLiveCurrencies()
    }
    
    func refreshLiveCurrencies() {
        interactor?.getLiveCurrencies()
    }
    
    func getCurrencyDisplayData(for code: String?) -> (currencyCode: String, currencyName: String, exchangeRateStr: String) {
        guard let code = code,
              let rate = currencyRates[code] else {
            return ("n/a", "n/a", "n/a")
        }
        
        let currencyName = CurrencyHelper.instance.getCurrencyName(forCurrencyCode: code)
        let exchangeRateStr = CurrencyHelper.instance.changeFormat(for: rate, currencyCode: code)
        
        return (code, currencyName, exchangeRateStr)
    }
    
    func getSourceCurrencyDisplayData() -> (currencyCode: String, currencyName: String, currencySymbol: String) {
        guard let code = interactor?.choosedCurrency else {
            return ("n/a", "n/a", "n/a")
        }
        
        let currencyName = CurrencyHelper.instance.getCurrencyName(forCurrencyCode: code)
        let currencySymbol = CurrencyHelper.instance.getCurrencySymbol(forCurrencyCode: code)
        
        return (code, currencyName, currencySymbol)
    }
}

//  MARK: - INTERACTOR -> PRESENTER
extension CurrencyPresenter: CurrencyInteractorOutputProtocol {
    func changedCurrencyRates(with data: [String: Double], originalData: [CurrencyLocalModel], deletions: [Int], insertions: [Int], modifications: [Int]) {
        currencyRates = data
        displayCurrencies = originalData.map { $0.code }
        view?.updateCurrencyList(deletions: deletions, insertions: insertions, modifications: modifications)
    }
    
    func finishedLiveCurrenciesCall() {
        view?.endRefreshControl()
    }
}
