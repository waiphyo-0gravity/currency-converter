//
//  CurrencyRouter.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import UIKit

class CurrencyRouter: CurrencyRouterProtocol {
    static func createModule() -> UIViewController? {
        guard let view = UIViewController.CurrencyViewController as? CurrencyViewController else { return nil }
        
        let router: CurrencyRouterProtocol = CurrencyRouter()
        var presenter: CurrencyPresenterProtocol & CurrencyInteractorOutputProtocol = CurrencyPresenter()
        var interactor: CurrencyInteractorInputProtocol & CurrencyWebServiceOutputProtocol = CurrencyInteractor()
        let localStorage: CurrencyLocalStorageProtocol = CurrencyLocalStorage()
        var webService: CurrencyWebServiceInputProtocol = CurrencyWebService()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.localStorage = localStorage
        interactor.webService = webService
        webService.interactor = interactor
        return view
    }
}
