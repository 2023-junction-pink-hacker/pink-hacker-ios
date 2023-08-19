//
//  UILabel+.swift
//  PinkHacker
//
//  Created by 김가영 on 2023/08/20.
//

import UIKit

extension UILabel {
    convenience init(weight: GellixFontWeight, size: CGFloat = 18, color: UIColor) {
        self.init(frame: .zero)
        font = .gellizFont(weight: weight, size: size)
        textColor = color
    }
}
