//
//  CurrencyWebServiceInputMock.swift
//  currency-converterTests
//
//  Created by Wai Phyo on 8/8/21.
//

import Foundation
@testable import currency_converter

class CurrencyWebServiceInputMock: CurrencyWebServiceInputProtocol {
    var interactor: CurrencyWebServiceOutputProtocol?
    
    //  MARK: - Mock variables.
    var apiCallState: APICallState = .success
    let mockData = MockData()
    
    enum APICallState {
        case success, fail(error: CurrencyError)
        
        var isSuccess: Bool {
            switch self {
            case .success:
                return true
            case .fail:
                return false
            }
        }
        
        var error: Error? {
            guard case .fail(let errState) = self else { return nil }
            
            switch errState {
            case .nointernet:
                return NSError(domain: "", code: NSURLErrorNotConnectedToInternet, userInfo: [:])
            case .timeout:
                return NSError(domain: "", code: NSURLErrorTimedOut, userInfo: [:])
            default:
                return errState
            }
        }
        
        var status: Int {
            guard case .fail(let errState) = self else { return 200 }
            
            switch errState {
            case .httperror(let errStatus, _):
                return errStatus
            default:
                return -1000
            }
        }
    }
    
    func callLiveCurrencies() {
        interactor?.gotLiveCurrencies(
            success: apiCallState.isSuccess,
            data: apiCallState.isSuccess ? mockData.successApiRateData : mockData.failedApiRateData,
            error: apiCallState.error,
            status: apiCallState.status
        )
    }
}
