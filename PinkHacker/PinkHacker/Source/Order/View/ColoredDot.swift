//
//  ColoredDot.swift
//  PinkHacker
//
//  Created by 김가영 on 2023/08/19.
//

import UIKit

final class ColoredDot: UIView {
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 12.0, height: 12.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(color: UIColor? = nil) {
        super.init(frame: .zero)
        backgroundColor = color
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
    }
}
