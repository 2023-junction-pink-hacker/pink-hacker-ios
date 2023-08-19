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
}

extension UIImage {
    static let btn_apple_button: UIImage = .init(.btn_apple_button)
    static let ic_location: UIImage = .init(.ic_location)
    static let ic_down_arrow: UIImage = .init(.ic_down_arrow)
}

extension UIImage {
    private convenience init(_ asset: ImageAsset) {
        self.init(named: asset.rawValue)!
    }
}
