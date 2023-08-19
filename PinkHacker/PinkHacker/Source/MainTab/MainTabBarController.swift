//
//  MainTabBarController.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/19.
//

import UIKit
import Then

final class MainTabBarController: UITabBarController {
    private var tabItems: [MainTab] = [.home, .myPage]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension MainTabBarController {
    private func setupUI() {
        self.tabBar.do {
            $0.tintColor = .black
            $0.backgroundColor = .white
            $0.itemSpacing = 120
            $0.itemPositioning = .centered
        }
        
        setViewControllers(viewControllers(of: self.tabItems), animated: false)
    }
}

extension MainTabBarController {
    private func viewControllers(of tabItems: [MainTab]) -> [UIViewController] {
        return tabItems.map { tab in
            let viewController: UIViewController
            switch tab {
            case .home:
                viewController = UIViewController()
                viewController.view.backgroundColor = .blue
            case .myPage:
                viewController = UIViewController()
                viewController.view.backgroundColor = .red
            }
            viewController.tabBarItem = tab.asTabBarItem()
            return viewController
        }
    }
}
