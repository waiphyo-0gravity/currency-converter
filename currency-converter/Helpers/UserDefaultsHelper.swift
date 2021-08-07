//
//  UserDefaultsHelper.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/7/21.
//

import Foundation

class UserDefaultsHelper {
    @nonobjc class var choosedCurrency: String? {
        get {
            return UserDefaults.standard.value(forKey: "choosedCurrency") as? String
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "choosedCurrency")
        }
    }
}
