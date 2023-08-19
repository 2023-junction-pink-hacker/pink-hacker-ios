//
//  NSMutableAttributedString+.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/19.
//

import Foundation

public extension NSMutableAttributedString {
    func appending(string: String, attributes: [NSAttributedString.Key : Any]) -> NSMutableAttributedString {
        let text = NSAttributedString(string: string, attributes: attributes)
        append(text)
        return self
    }
}
