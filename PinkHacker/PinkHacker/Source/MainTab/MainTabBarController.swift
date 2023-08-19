//
//  MainTabBarController.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/19.
//

import UIKit
import Then

final class MainTabBarController: UITabBarController {
    private var tabItems: [MainTab] = [.home, .myOrder]
    private let uploadButton = UIButton()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        object_setClass(self.tabBar, MainTabBar.self)
        let fontAttributes = [NSAttributedString.Key.font: UIFont.gellizFont(weight: .semibold, size: 16)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    final class MainTabBar: UITabBar {
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var sizeThatFits = super.sizeThatFits(size)
            sizeThatFits.height = 58 + safeAreaBottomPadding
            return sizeThatFits
        }
    }
}

extension MainTabBarController {
    private func setupUI() {
        self.tabBar.do {
            $0.tintColor = Const.selectedColor
            $0.backgroundColor = .white
            $0.itemSpacing = 120
            $0.itemPositioning = .centered
        }
        self.uploadButton.do {
            $0.backgroundColor = Const.uploadColor
            $0.layer.cornerRadius = 30
            $0.layer.masksToBounds = true
            $0.setImage(.ic_plus, for: .normal)
            
            view.addSubview($0)
        }
        self.uploadButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.tabBar).offset(-20)
            make.size.equalTo(60)
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
                viewController = ViewController()
                viewController.view.backgroundColor = .blue
            case .myOrder:
                viewController = MyOrderViewController()
            }
            viewController.tabBarItem = tab.asTabBarItem()
            return viewController
        }
    }
}

private extension MainTabBarController {
    enum Const {
        static let backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.93, alpha: 1)
        static let uploadColor = UIColor(red: 1, green: 0.52, blue: 0.37, alpha: 1)
        static let selectedColor = UIColor(red: 0.31, green: 0.31, blue: 0.29, alpha: 1)
        static let unselectedColor = UIColor(red: 0.7, green: 0.7, blue: 0.63, alpha: 1)
    }
}
