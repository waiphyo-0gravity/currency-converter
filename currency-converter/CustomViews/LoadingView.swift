//
//  LoadingView.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/7/21.
//

import UIKit
import Lottie

class LoadingView: UIVisualEffectView {
    private lazy var lottieView: AnimationView = {
        let temp = AnimationView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.animation = Animation.named("loading")
        temp.loopMode = .loop
        temp.animationSpeed = 2
        temp.play()
        return temp
    }()
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        initial()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initial()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    
    func startAnimation(isAnimate: Bool = true) {
        lottieView.play()
        animateView(isShow: true, isAnimate: isAnimate)
    }
    
    func stopAnimation(isAnimate: Bool = true) {
        lottieView.pause()
        animateView(isShow: false, isAnimate: isAnimate)
    }
}

//  MARK: Private functions.
extension LoadingView {
    private func initial() {
        effect = UIBlurEffect(style: .light)
        
        contentView.addSubview(lottieView)
        lottieView.widthAnchor.constraint(equalToConstant: 108).isActive = true
        lottieView.heightAnchor.constraint(equalToConstant: 108).isActive = true
        lottieView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        lottieView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        animateView(isShow: false, isAnimate: false)
    }
    
    private func animateView(isShow: Bool, isAnimate: Bool) {
        UIView.animate(
            withDuration: isAnimate ? 0.3 : 0,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.7,
            options: .curveEaseInOut, animations: {[unowned self] in
            alpha = isShow ? 1 : 0
        })
    }
}
