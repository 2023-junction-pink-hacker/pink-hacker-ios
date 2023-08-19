//
//  UIImage+.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/19.
//

import UIKit

enum ImageAsset: String {
    case btn_apple_button
}

extension UIImage {
    static let btn_apple_button: UIImage = .init(.btn_apple_button)
}

extension UIImage {
    private convenience init(_ asset: ImageAsset) {
        self.init(named: asset.rawValue)!
    }
}
