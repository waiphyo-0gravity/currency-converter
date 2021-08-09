//
//  CurrencyWebServices.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import Foundation

class CurrencyWebService: CurrencyWebServiceInputProtocol {
    weak var interactor: CurrencyWebServiceOutputProtocol?
    
    //  MARK: Private variables.
    private var session: URLSessionTask?
    
    func callLiveCurrencies() {
        session?.cancel()
        
        guard var urlComponents = EndPoints.Currency.live.url else { return }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "access_key", value: APIHelper.accessKey)
        ]
        
        guard let url = urlComponents.url else { return }
        
        session = APIHelper.session.dataTask(with: url) {[unowned self] data, response, error in
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            
            DispatchQueue.main.async {
                guard let data = data else {
                    interactor?.gotLiveCurrencies(success: false, data: nil, error: error, status: statusCode)
                    return
                }
                
                do {
                    let mappedData = try JSONDecoder().decode(CurrencyModel.self, from: data)
                    interactor?.gotLiveCurrencies(success: true, data: mappedData, error: nil, status: statusCode)
                } catch let mappingError {
                    interactor?.gotLiveCurrencies(success: false, data: nil, error: mappingError, status: statusCode)
                }
            }
        }
        
        session?.resume()
    }
}
