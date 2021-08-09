//
//  APIHelper.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import Foundation

struct APIHelper {
    static let baseURL = "http://api.currencylayer.com"
    
    static var session: URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = Self.timeoutInterval
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        return URLSession(configuration: config)
    }
    
    static var accessKey: String = {
        guard let path = Bundle.main.path(forResource: "API-Info", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let accessKey = plist["ACCESS_KEY"] as? String else { return "" }
        
        return accessKey
    }()
    
    //  MARK: - Private variables.
    private static let timeoutInterval: TimeInterval = 10
}
