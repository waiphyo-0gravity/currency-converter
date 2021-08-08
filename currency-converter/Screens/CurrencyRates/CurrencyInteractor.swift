//
//  CurrencyInteractor.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import Foundation
import RealmSwift

class CurrencyInteractor: CurrencyInteractorInputProtocol {
    weak var presenter: CurrencyInteractorOutputProtocol?
    
    var localStorage: CurrencyLocalStorageProtocol? {
        didSet {
            observeLocalCurrencyRates()
        }
    }
    
    var webService: CurrencyWebServiceInputProtocol?
    
    var choosedCurrency: String? {
        get { localStorage?.getChoosedCurrency() }
        
        set { localStorage?.setChoosedCurrency(with: newValue) }
    }
    
    var areRatesSavedLocally: Bool? { (localStorage?.localCurrencyRates?.count ?? 0) > 0 }
    
    //  MARK: Private variables.
    private var localCurrencyRatesNotiToken: NotificationToken?
    
    deinit {
        localCurrencyRatesNotiToken?.invalidate()
    }
    
    func getLiveCurrencies() {
        webService?.callLiveCurrencies()
    }
}
//  MARK: - Private functions.
extension CurrencyInteractor {
    private func observeLocalCurrencyRates() {
        localCurrencyRatesNotiToken = localStorage?.localCurrencyRates?.observe() {[unowned self] changes in
            switch changes {
            case .initial(let data):
                let mappedData = mappingCurrencyModel(for: data)
                
                presenter?.changedCurrencyRates(
                    with: mappedData.data,
                    originalData: mappedData.original,
                    deletions: [],
                    insertions: [],
                    modifications: []
                )
            case .update(let data, let deletions, let insertions, let modifications):
                let mappedData = mappingCurrencyModel(for: data)
                
                presenter?.changedCurrencyRates(
                    with: mappedData.data,
                    originalData: mappedData.original,
                    deletions: deletions,
                    insertions: insertions,
                    modifications: modifications
                )
            case .error(let error):
                print(error)
            }
        }
    }
    
    private func mappingCurrencyModel(for data: Results<CurrencyLocalModel>) -> (data: [String: Double], original: [CurrencyLocalModel]) {
        var results = [String: Double]()
        var original = [CurrencyLocalModel]()
        
        data.forEach { currency in
            results[currency.code] = currency.rate
            original.append(currency)
        }
        
        return (results, original)
    }
}

//  MARK: - WEB_SERVICE -> INTERACTOR
extension CurrencyInteractor: CurrencyWebServiceOutputProtocol {
    func gotLiveCurrencies(success: Bool, data: CurrencyModel?, error: Error?, status: Int) {
        presenter?.finishedLiveCurrenciesCall()
        
        if success,
           let quotes = data?.quotes,
           let source = data?.source {
            localStorage?.changeCurrencyData(to: quotes, source: source)
        }
    }
}
