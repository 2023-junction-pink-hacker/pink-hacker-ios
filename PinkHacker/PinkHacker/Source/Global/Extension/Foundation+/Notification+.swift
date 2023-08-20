//
//  Notification+.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/19.
//

import Foundation

extension Notification.Name {
    /// ViewOrder버튼이 눌렸을 때
    static let didTapViewOrder = Notification.Name(rawValue: "didTapViewOrder")
    static let registerRecipe = Notification.Name(rawValue: "registerRecipe")
}
