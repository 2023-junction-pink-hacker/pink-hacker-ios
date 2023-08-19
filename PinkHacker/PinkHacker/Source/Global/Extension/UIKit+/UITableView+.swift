//
//  UITableView+.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/19.
//

import UIKit

extension UITableView {
    public func registerCell<Cell: UITableViewCell>(_ cellType: Cell.Type) {
        let reuseIdentifier = String(describing: cellType)
        self.register(cellType, forCellReuseIdentifier: reuseIdentifier)
    }
    
    public func dequeueCell<Cell: UITableViewCell>(_ cellType: Cell.Type, for indexPath: IndexPath) -> Cell? {
        let reuseIdentifier = String(describing: cellType)
        return self.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? Cell
    }
    
}
