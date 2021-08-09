//
//  CurrencyPresenter.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import UIKit

class CurrencyPresenter: CurrencyPresenterProtocol {
    weak var view: CurrencyViewProtocol?
    var interactor: CurrencyInteractorInputProtocol?
    var router: CurrencyRouterProtocol?
    private(set)var displayCurrencies = [String]()
    private(set)var sourceValue: Double = 1.00
    
    var sourceCurrencyIndex: Int? {
        guard let choosedCurrency = interactor?.choosedCurrency else { return nil }
        
        return displayCurrencies.firstIndex(of: choosedCurrency)
    }
    
    //  MARK: Private variables
    private var currencyRates = [String: Double]()
    private var timer: Timer?
    
    //  MARK: 30min for rates refreshing api call.
    private var timerInterval: TimeInterval = 1800
    
    deinit {
        stopRefreshingCurrencyRatesTimer()
    }
    
    func viewDidLoad() {
        view?.updateSourceCurrencyUIs(isAnimate: false)
        interactor?.getLiveCurrencies()
        
        if interactor?.areRatesSavedLocally != true {
            view?.changeLoadingState(isLoading: true, isAnimate: true)
        }
    }
    
    func refreshLiveCurrencies() {
        interactor?.getLiveCurrencies()
    }
    
    func getCurrencyDisplayData(for code: String?) -> (currencyCode: String, currencyName: String, exchangeRateStr: String) {
        guard let code = code,
              let currentSource = interactor?.choosedCurrency,
              let exchangeRate = getExchangeRate(from: currentSource, to: code) else {
            return ("n/a", "n/a", "n/a")
        }
        
        let currencyName = CurrencyHelper.instance.getCurrencyName(forCurrencyCode: code)
        let exchangeRateStr = CurrencyHelper.instance.changeFormat(for: exchangeRate, currencyCode: code)
        
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
    
    func changeSourceCurrency(with code: String) {
        interactor?.choosedCurrency = code
        
        view?.updateSourceCurrencyUIs(isAnimate: true)
        
        refreshAllCurrencyRates(isAnimate: true)
    }
    
    func changeSourceValue(to value: Double) {
        sourceValue = value
        refreshAllCurrencyRates(isAnimate: false)
    }
    
    func showError(view: UIViewController, error: CurrencyError) {
        let isSavedLocally = interactor?.areRatesSavedLocally == true
        
        router?.showErrorView(view: view, for: error, isCancelBtnInclude: isSavedLocally) {[unowned self] in
            interactor?.getLiveCurrencies()
        }
    }
    
    //  MARK: Selectors.
    @objc func handleScheduledTimer() {
        interactor?.getLiveCurrencies()
    }
}

//  MARK: - Private functions.
extension CurrencyPresenter {
    private func getExchangeRate(from fromCode: String, to toCode: String) -> Double? {
        guard let fromRate = currencyRates[fromCode],
              let toRate = currencyRates[toCode] else { return nil }
        
        let toUSDollar = sourceValue / fromRate
        let actualRate = toUSDollar * toRate
        
        return actualRate
    }
    
    private func refreshAllCurrencyRates(isAnimate: Bool) {
        let modifications = displayCurrencies.enumerated().map { $0.offset }
        view?.updateCurrencyList(deletions: [], insertions: [], modifications: isAnimate ? modifications : [])
    }
    
    private func restartTimer() {
        stopRefreshingCurrencyRatesTimer()
        startRefreshingCurrencyRatesTimer()
    }
    
    private func startRefreshingCurrencyRatesTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(handleScheduledTimer), userInfo: nil, repeats: true)
    }
    
    private func stopRefreshingCurrencyRatesTimer() {
        timer?.invalidate()
    }
}

//  MARK: - INTERACTOR -> PRESENTER
extension CurrencyPresenter: CurrencyInteractorOutputProtocol {
    func changedCurrencyRates(with data: [String: Double], originalData: [CurrencyLocalModel], deletions: [Int], insertions: [Int], modifications: [Int]) {
        currencyRates = data
        displayCurrencies = originalData.map { $0.code }
        view?.updateCurrencyList(deletions: deletions, insertions: insertions, modifications: modifications)
        
        guard interactor?.areRatesSavedLocally == true else { return }
        
        view?.changeLoadingState(isLoading: false, isAnimate: true)
    }
    
    func finishedLiveCurrenciesCall() {
        view?.endRefreshControl()
        restartTimer()
    }
    
    func handleErrors(error: CurrencyError) {
        view?.gotError(error: error)
    }
}
