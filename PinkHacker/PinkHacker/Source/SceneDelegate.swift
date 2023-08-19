//
//  SceneDelegate.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/19.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let rootViewController = MainTabBarController()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window
    }
}
