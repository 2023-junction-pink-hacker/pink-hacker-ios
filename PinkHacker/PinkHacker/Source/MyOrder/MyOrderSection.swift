//
//  MyOrderSection.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/20.
//

import Foundation

enum MyOrderSectionType {
    case recent
    case recipe
    
    var headerTitle: String {
        switch self {
        case .recent: return "Recent Orders"
        case .recipe: return "My Recipes"
        }
    }
}

struct MyOrderSection: Hashable {
    typealias Item = MyOrderSectionItem
    
    let type: MyOrderSectionType
    let items: [Item]
}

enum MyOrderSectionItem: Hashable {
    case myRecent(RecentOrderCell.ViewModel)
    case myRecipe(MyRecipeCell.ViewModel)
}
