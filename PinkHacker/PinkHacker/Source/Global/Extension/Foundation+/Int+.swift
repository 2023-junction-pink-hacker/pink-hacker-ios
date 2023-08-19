//
//  Int+.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/19.
//

import Foundation

public extension Int {
    var commaOfThousand: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: self as NSNumber) ?? "\(self)"
    }
}
