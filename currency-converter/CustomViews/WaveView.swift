//
//  WaveView.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/7/21.
//

import UIKit

@IBDesignable class WaveView: UIView {
    
    @IBInspectable var fillColor: UIColor = .white
    
    override func layoutSubviews() {
        super.layoutSubviews()
        draw(frame)
    }
    
    override func draw(_ rect: CGRect) {
        let curveWidth: CGFloat = 15
        let curveHeight: CGFloat = 10
        let path = UIBezierPath()
        let centerY = frame.height - (curveHeight / 2)
        
        path.move(to: .init(x: 0, y: frame.height))
        
        path.addLine(to: .init(x: 0, y: centerY))
        
        var index: CGFloat = 0
        
        while index * curveWidth < frame.width {
            let point = CGPoint(x: curveWidth * (index + 1), y: centerY)
            let controlPointX = (curveWidth * index) + (curveWidth / 2)
            let controlPointY = index.remainder(dividingBy: 2) == 0 ? centerY-curveHeight : frame.height+curveHeight/2
            
            path.addQuadCurve(to: point, controlPoint: .init(x: controlPointX, y: controlPointY))
            
            index += 1
        }
        
        path.addLine(to: .init(x: frame.width, y: frame.height))
        
        fillColor.setFill()
        path.fill()
        
        let pathLayer = CAShapeLayer()
        pathLayer.path = path.cgPath
        pathLayer.frame = bounds
        
        layer.mask = pathLayer
    }
}
