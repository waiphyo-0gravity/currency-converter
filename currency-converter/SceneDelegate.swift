//
//  SceneDelegate.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        AppLaunchHelper.initial(forWindow: window)
    }
}

