//
//  AppLaunchHelper.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import UIKit

struct AppLaunchHelper {
    static func initial(forWindow window: UIWindow?) {
        setInitialChoosedCurrency()
        
        guard let window = window,
              let currencyVC = CurrencyRouter.createModule() else { return }
        
        window.rootViewController = currencyVC
        window.makeKeyAndVisible()
    }
    
    private static func setInitialChoosedCurrency() {
        guard UserDefaultsHelper.choosedCurrency == nil else { return }
        
        UserDefaultsHelper.choosedCurrency = "USD"
    }
}
