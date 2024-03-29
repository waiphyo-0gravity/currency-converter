//
//  CurrencyTableViewCell.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell, NibableCellProtocol {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var symbolView: CurrencySymbolView!
    @IBOutlet weak var currencyNameLbl: UILabel!
    @IBOutlet weak var exchangeRateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    func setData(code: String?, currencyName: String?, fomattedCurrencyRate: String?) {
        if let code = code {
            symbolView.code = code
        }
        
        currencyNameLbl.text = currencyName
        
        if let regex = try? NSRegularExpression(pattern: "([0-9.,]+)"),
           let fomattedCurrencyRate = fomattedCurrencyRate,
           let firstMatch = regex.matches(in: fomattedCurrencyRate, range: NSRange(fomattedCurrencyRate.startIndex..., in: fomattedCurrencyRate)).first {
            let mutableStr = NSMutableAttributedString(string: fomattedCurrencyRate)
            
            mutableStr.addAttributes(
                [
                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)
                ],
                range: firstMatch.range
            )
            
            exchangeRateLbl.attributedText = mutableStr
        } else {
            exchangeRateLbl.text = fomattedCurrencyRate
        }
    }
}

//  MARK: - Private functions
extension CurrencyTableViewCell {
    private func initial() {
        containerView.layer.cornerRadius = 24
    }
}
