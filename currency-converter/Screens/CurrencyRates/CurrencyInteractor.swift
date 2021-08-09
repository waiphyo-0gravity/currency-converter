//
//  CurrencyInteractor.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import Foundation
import RealmSwift

enum CurrencyError: Error, Equatable {
    case nointernet, timeout, httperror(status: Int, msg: String?), databaseerror, unknown
    
    static func == (lhs: CurrencyError, rhs: CurrencyError) -> Bool {
        switch (lhs, rhs) {
        case (.nointernet, .nointernet),
             (.timeout, .timeout),
             (.unknown, .unknown),
             (.databaseerror, .databaseerror):
            return true
        case (.httperror(let lstatus, let lmsg), .httperror(let rstatus, let rmsg)):
            return lstatus == rstatus && lmsg == rmsg
        default:
            return false
        }
    }
    
    var displayData: (title: String, message: String) {
        switch self {
        case .nointernet:
            return ("No internet!", "Please check your connection and try again.")
        case .timeout:
            return ("Timeout!", "Connection timeout.")
        case .httperror(let status, let msg):
            return ("Request error!", msg != nil ? "\(msg!)" : "Status is \(status).")
        case .databaseerror:
            return ("Database error!", "Something is wrong with database.")
        case .unknown:
            return ("Unknown error!", "Unknown error occurs.")
        }
    }
}

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
            case .error(_):
                presenter?.handleErrors(error: .databaseerror)
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
    
    private func mappingNetworkError(for error: Error?, statusCode: Int, data: CurrencyModel?) -> CurrencyError {
        let nsError = error as NSError?
        
        switch true {
        case nsError?.code == NSURLErrorNotConnectedToInternet:
            return .nointernet
        case nsError?.code == NSURLErrorTimedOut:
            return .timeout
        case 100..<600 ~= statusCode:
            return .httperror(status: data?.error?.code ?? statusCode, msg: data?.error?.info)
        default:
            return .unknown
        }
    }
}

//  MARK: - WEB_SERVICE -> INTERACTOR
extension CurrencyInteractor: CurrencyWebServiceOutputProtocol {
    func gotLiveCurrencies(success: Bool, data: CurrencyModel?, error: Error?, status: Int) {
        presenter?.finishedLiveCurrenciesCall()
        print(data, status)
        if success,
           let quotes = data?.quotes,
           let source = data?.source {
            localStorage?.changeCurrencyData(to: quotes, source: source)
        } else {
            let mappedError = mappingNetworkError(for: error, statusCode: status, data: data)
            presenter?.handleErrors(error: mappedError)
        }
    }
}
