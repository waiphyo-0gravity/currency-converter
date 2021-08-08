//
//  CurrencyLocalModel.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import Foundation
import RealmSwift

class CurrencyLocalModel: Object {
    @Persisted(primaryKey: true) var code: String
    @Persisted var rate: Double
    
    static func createModel(code: String, rate: Double) -> CurrencyLocalModel {
        let model = CurrencyLocalModel()
        model.code = code
        model.rate = rate
        
        return model
    }
}
