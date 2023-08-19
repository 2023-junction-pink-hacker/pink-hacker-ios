//
//  UICollectionView+.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/19.
//

import UIKit

extension UICollectionView {
    public func registerCell<Cell: UICollectionViewCell>(_ cellType: Cell.Type) {
        let reuseIdentifier = String(describing: cellType)
        self.register(cellType, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    public func dequeueCell<Cell: UICollectionViewCell>(_ cellType: Cell.Type, for indexPath: IndexPath) -> Cell? {
        let reuseIdentifier = String(describing: cellType)
        return self.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? Cell
    }
    
}
