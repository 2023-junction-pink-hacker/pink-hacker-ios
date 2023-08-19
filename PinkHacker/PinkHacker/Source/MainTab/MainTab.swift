//
//  MainTab.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/19.
//

import UIKit

enum MainTab: Int, CaseIterable {
    case home
    case myPage
}

extension MainTab {
    var title: String {
        switch self {
        case .home: return "홈"
        case .myPage: return "MY"
        }
    }
    
    var selectedIcon: UIImage? {
        switch self {
        case .home: return UIImage(systemName: "")
        case .myPage: return UIImage(systemName: "")
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .home: return UIImage(systemName: "")
        case .myPage: return UIImage(systemName: "")
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
