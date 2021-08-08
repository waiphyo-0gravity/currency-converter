//
//  CurrencyLocalStorageMock.swift
//  currency-converterTests
//
//  Created by Wai Phyo on 8/8/21.
//

import Foundation
import RealmSwift
@testable import currency_converter

class CurrencyLocalStorageMock: CurrencyLocalStorageProtocol {
    var localCurrencyRates: Results<CurrencyLocalModel>?
    private(set) var realm: Realm?
    
    //  MARK: Mock variables.
    private var choosedCurrency: String?
    
    init(choosedCurrency: String = "USA") {
        let config = Realm.Configuration(inMemoryIdentifier: "CurrencyConverterTest")
        realm = try? Realm(configuration: config)
        
        localCurrencyRates = realm?.objects(CurrencyLocalModel.self)
        self.choosedCurrency = choosedCurrency
    }
    
    func changeCurrencyData(to data: [String : Double], source: String) {
        try? realm?.write {
            data.keys.sorted().forEach { key in
                let value = data[key] ?? 0
                
                let trimedKey = CurrencyHelper.instance.trimSourceCurrencyCode(for: key, source: source)
                
                if let record = localCurrencyRates?.filter("code = %@", trimedKey).first {
                    if record.rate != value {
                        record.rate = value
                    }
                } else {
                    let newRecord = CurrencyLocalModel()
                    newRecord.code = trimedKey
                    newRecord.rate = value
                    realm?.add(newRecord)
                }
            }
        }
    }
    
    func getChoosedCurrency() -> String? { choosedCurrency }
    
    func setChoosedCurrency(with value: String?) {
        choosedCurrency = value
    }
    
    //  MARK: Mork functions.
    func clearAllData() {
        try? realm?.write {[unowned self] in
            realm?.deleteAll()
        }
    }
}
