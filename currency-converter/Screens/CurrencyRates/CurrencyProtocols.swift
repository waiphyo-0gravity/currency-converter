//
//  CurrencyProtocols.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import UIKit
import RealmSwift

protocol CurrencyViewProtocol: AnyObject {
    var presenter: CurrencyPresenterProtocol? { get set }
    
    func updateCurrencyList(deletions: [Int], insertions: [Int], modifications: [Int])
    func endRefreshControl()
    func updateSourceCurrencyUIs(isAnimate: Bool)
    func changeLoadingState(isLoading: Bool, isAnimate: Bool)
    func gotError(error: CurrencyError)
}

protocol CurrencyPresenterProtocol {
    var view: CurrencyViewProtocol? { get set }
    var interactor: CurrencyInteractorInputProtocol? { get set }
    var router: CurrencyRouterProtocol? { get set }
    var displayCurrencies: [String] { get }
    var sourceCurrencyIndex: Int? { get }
    var sourceValue: Double { get }
    
    func viewDidLoad()
    func refreshLiveCurrencies()
    func getCurrencyDisplayData(for code: String?) -> (currencyCode: String, currencyName: String, exchangeRateStr: String)
    func getSourceCurrencyDisplayData() -> (currencyCode: String, currencyName: String, currencySymbol: String)
    func changeSourceCurrency(with code: String)
    func changeSourceValue(to value: Double)
    func showError(view: UIViewController, error: CurrencyError)
}

protocol CurrencyInteractorInputProtocol {
    var presenter: CurrencyInteractorOutputProtocol? { get set }
    var localStorage: CurrencyLocalStorageProtocol? { get set }
    var webService: CurrencyWebServiceInputProtocol? { get set }
    var choosedCurrency: String? { get set }
    var areRatesSavedLocally: Bool? { get }
    
    func getLiveCurrencies()
}

protocol CurrencyInteractorOutputProtocol: AnyObject {
    func changedCurrencyRates(with data: [String: Double], originalData: [CurrencyLocalModel], deletions: [Int], insertions: [Int], modifications: [Int])
    func finishedLiveCurrenciesCall()
    func handleErrors(error: CurrencyError)
}

protocol CurrencyRouterProtocol {
    static func createModule() -> UIViewController?
    func showErrorView(view: UIViewController, for error: CurrencyError, isCancelBtnInclude: Bool, handleRetry: (()->Void)?)
}

protocol CurrencyLocalStorageProtocol {
    var realm: Realm? { get }
    var localCurrencyRates: Results<CurrencyLocalModel>? { get }
    
    func changeCurrencyData(to data: [String: Double], source: String)
    func getChoosedCurrency() -> String?
    func setChoosedCurrency(with value: String?)
}

protocol CurrencyWebServiceInputProtocol {
    var interactor: CurrencyWebServiceOutputProtocol? { get set }
    
    func callLiveCurrencies()
}

protocol CurrencyWebServiceOutputProtocol: AnyObject {
    func gotLiveCurrencies(success: Bool, data: CurrencyModel?, error: Error?, status: Int)
}
