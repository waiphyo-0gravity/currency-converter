//
//  CurrencyLocalStorages.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import Foundation
import RealmSwift

class CurrencyLocalStorage: CurrencyLocalStorageProtocol {
    private(set) var localCurrencyRates: Results<CurrencyLocalModel>?
    
    // MARK: Private variables.
    private(set) var realm: Realm?
    
    init() {
        do{
            realm = try Realm()
            localCurrencyRates = realm?.objects(CurrencyLocalModel.self)
        } catch let realmError {
            print(realmError)
        }
    }
    
    func changeCurrencyData(to data: [String: Double], source: String) {
        do {
            try realm?.write {
                insertCurrencyData(data: data, source: source)
            }
        } catch let error {
            print(error)
        }
    }
    
    func getChoosedCurrency() -> String? { UserDefaultsHelper.choosedCurrency }
    
    func setChoosedCurrency(with value: String?) {
        UserDefaultsHelper.choosedCurrency = value
    }
    
    //  MARK: Private functions.
    private func insertCurrencyData(data: [String: Double], source: String) {
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
