//
//  CurrencySymbolView.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import UIKit

@IBDesignable
class CurrencySymbolView: UIView {
    @IBInspectable var code: String = "USD" {
        didSet {
            setUpSymbol()
        }
    }
    
    @IBInspectable var textColor: UIColor = .white {
        didSet {
            setUpLblColor()
        }
    }
    
    var font: UIFont = .boldSystemFont(ofSize: 13) {
        didSet {
            setUpLblFont()
        }
    }
    
    private lazy var symbolLbl: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initial()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    private func initial() {
        layoutIfNeeded()
        layer.cornerRadius = min(frame.size.width, frame.size.height) / 2
        clipsToBounds = true
        
        addSubview(symbolLbl)
        symbolLbl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        symbolLbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        setUpSymbol()
        setUpLblColor()
        setUpLblFont()
    }
    
    private func setUpSymbol() {
        symbolLbl.text = CurrencyHelper.instance.getCurrencySymbol(forCurrencyCode: code)
    }
    
    private func setUpLblColor() {
        symbolLbl.textColor = textColor
    }
    
    private func setUpLblFont() {
        symbolLbl.font = font
    }
}
