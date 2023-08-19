//
//  MainTab.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/19.
//

import UIKit

enum MainTab: Int, CaseIterable {
    case home
    case myOrder
}

extension MainTab {
    var title: String {
        switch self {
        case .home: return "Home"
        case .myOrder: return "Orders"
        }
    }
    
    var selectedIcon: UIImage? {
        switch self {
        case .home: return .ic_home_selected.resized(width: 32, height: 32)
        case .myOrder: return .ic_orders_selected.resized(width: 32, height: 32)
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .home: return .ic_home.resized(width: 32, height: 32)
        case .myOrder: return .ic_order.resized(width: 32, height: 32)
        }
    }
}

extension MainTab {
    func asTabBarItem() -> UITabBarItem {
        return UITabBarItem(
            title: self.title,
            image: self.icon,
            selectedImage: self.selectedIcon
        )
    }
}
