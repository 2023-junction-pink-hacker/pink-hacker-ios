//
//  UIApplication+.swift
//  PinkHacker
//
//  Created by 김가영 on 2023/08/19.
//

import UIKit

extension UIApplication {
    var windowScene: UIWindowScene? {
        connectedScenes.first as? UIWindowScene
    }
    
    var keyWindow: UIWindow? {
        windowScene?.windows.first { $0.isKeyWindow }
    }
}
