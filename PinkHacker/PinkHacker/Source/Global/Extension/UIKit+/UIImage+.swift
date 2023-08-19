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
    case ic_progress_1
    case ic_progress_2
    case ic_progress_3
    case ic_home
    case ic_home_selected
    case ic_order
    case ic_orders_selected
    case ic_plus
    case ic_time_home
    case ic_love
    case img_test_food
}

extension UIImage {
    static let btn_apple_button: UIImage = .init(.btn_apple_button)
    static let ic_location: UIImage = .init(.ic_location)
    static let ic_down_arrow: UIImage = .init(.ic_down_arrow)
    static let img_pizza: UIImage = .init(.img_pizza)
    static let ic_clock: UIImage = .init(.ic_clock)
    static let ic_back: UIImage = .init(.ic_back)
    static let ic_progress_1: UIImage = .init(.ic_progress_1)
    static let ic_progress_2: UIImage = .init(.ic_progress_2)
    static let ic_progress_3: UIImage = .init(.ic_progress_3)
    static let ic_home: UIImage = .init(.ic_home)
    static let ic_home_selected: UIImage = .init(.ic_home_selected)
    static let ic_order: UIImage = .init(.ic_order)
    static let ic_orders_selected: UIImage = .init(.ic_orders_selected)
    static let ic_plus: UIImage = .init(.ic_plus)
    static let ic_time_home: UIImage = .init(.ic_time_home)
    static let ic_love: UIImage = .init(.ic_love)
    static let img_test_food: UIImage = .init(.img_test_food)

}

extension UIImage {
    private convenience init(_ asset: ImageAsset) {
        self.init(named: asset.rawValue)!
    }
    
    public func resized(width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return renderImage
    }
    
    public func resized(side: CGFloat) -> UIImage {
        return self.resized(width: side, height: side)
    }
}
