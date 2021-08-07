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
}
