//
//  CurrencyRouter.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import UIKit

class CurrencyRouter: CurrencyRouterProtocol {
    func showErrorView(view: UIViewController, for error: CurrencyError, isCancelBtnInclude: Bool, handleRetry: (()->Void)?) {
        let displayErrData = error.displayData
        
        let alertVC = UIAlertController(title: displayErrData.title, message: displayErrData.message, preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) {_ in
            handleRetry?()
        }
        alertVC.addAction(retryAction)
        
        if isCancelBtnInclude {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertVC.addAction(cancelAction)
        }
        
        view.present(alertVC, animated: true)
    }
    
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
