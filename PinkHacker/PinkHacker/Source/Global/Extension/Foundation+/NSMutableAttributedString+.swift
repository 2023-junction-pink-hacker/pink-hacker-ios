//
//  NSMutableAttributedString+.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/19.
//

import UIKit

public extension NSMutableAttributedString {
    func appending(string: String, attributes: [NSAttributedString.Key : Any]) -> NSMutableAttributedString {
        let text = NSAttributedString(string: string, attributes: attributes)
        append(text)
        return self
    }
    
    struct PHAttributes {
        var weight: PHWeight
        var size: CGFloat
        var textColor: UIColor
        
        enum PHWeight {
            case gellix(GellixFontWeight)
            case spotify(SpotifyFontWeight)
        }
    }
    
    static func build(string: String?, attributes: PHAttributes) -> NSMutableAttributedString {
        var stringAttributes: [NSAttributedString.Key: Any] = [:]

        var font: UIFont
        switch attributes.weight {
        case let .gellix(weight):
            font = UIFont.gellizFont(weight: weight, size: attributes.size)
        case let .spotify(weight):
            font = UIFont.spotifyFont(weight: weight, size: attributes.size)
        }
        
        stringAttributes[.font] = font
        stringAttributes[.foregroundColor] = attributes.textColor
        stringAttributes[.kern] = -0.2
        
        return NSMutableAttributedString(string: string ?? "", attributes: stringAttributes)
    }
}

protocol KernAppliable: AnyObject {
    var phAttributedString: NSAttributedString? { get set }
    
    func setText(
        _ string: String?,
        attributes: NSMutableAttributedString.PHAttributes
    )
}

extension KernAppliable {
    func setText(
        _ string: String?,
        attributes: NSMutableAttributedString.PHAttributes
    ) {
        phAttributedString = NSMutableAttributedString.build(
            string: string,
            attributes: attributes
        )
    }
}

extension UILabel: KernAppliable {
    public var phAttributedString: NSAttributedString? {
        get { attributedText }
        set { attributedText = newValue }
    }
}

extension UITextField: KernAppliable {
    public var phAttributedString: NSAttributedString? {
        get { attributedText }
        set { attributedText = newValue }
    }
}
