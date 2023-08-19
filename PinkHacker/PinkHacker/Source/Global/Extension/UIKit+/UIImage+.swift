//
//  UIImage+.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/19.
//

import UIKit

enum ImageAsset: String {
    case btn_apple_button
    case ic_location
    case ic_down_arrow
    case img_pizza
    case ic_clock
    case ic_back
}

extension UIImage {
    static let btn_apple_button: UIImage = .init(.btn_apple_button)
    static let ic_location: UIImage = .init(.ic_location)
    static let ic_down_arrow: UIImage = .init(.ic_down_arrow)
    static let img_pizza: UIImage = .init(.img_pizza)
    static let ic_clock: UIImage = .init(.ic_clock)
    static let ic_back: UIImage = .init(.ic_back)
}

extension UIImage {
    private convenience init(_ asset: ImageAsset) {
        self.init(named: asset.rawValue)!
    }
}
