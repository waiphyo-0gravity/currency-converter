//
//  UIViewController+Extensions.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import UIKit

extension UIViewController {
    @nonobjc class var CurrencyViewController: UIViewController? {
        return UIStoryboard.currency.instantiateInitialViewController()
    }
}
