//
//  EndPoints.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import Foundation

protocol EndPoint {
    var url: URLComponents? { get }
    var path: String { get }
}

struct EndPoints {
    enum Currency: EndPoint {
        case live
        
        var url: URLComponents? {
            return URLComponents(string: "\(APIHelper.baseURL)\(path)")
        }
        
        var path: String {
            return "/live"
        }
    }
}
