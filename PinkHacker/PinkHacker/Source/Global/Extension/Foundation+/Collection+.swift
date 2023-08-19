//
//  Collection+.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/19.
//

import Foundation

extension Array {
    
    public subscript (safe index: Index) -> Element? {
        guard self.indices.contains(index) else { return nil }
        return self[index]
    }
}
extension Array where Element: Hashable {
    public func removeDuplicates() -> [Element] {
        return Set<Element>(self).map { $0 }
    }
}
extension Array {
    public var isNotEmpty: Bool { !self.isEmpty }
}
