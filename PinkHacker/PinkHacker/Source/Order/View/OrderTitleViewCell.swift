//
//  OrderTitleViewCell.swift
//  PinkHacker
//
//  Created by 김가영 on 2023/08/19.
//

import UIKit
import SnapKit

final class OrderTitleViewCell: UICollectionViewCell {
    
    static let height = 56.0
    var textfield: UITextField!
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: Self.height)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.93, alpha: 1)
        layer.cornerRadius = 10.0
        layer.masksToBounds = true
        
        let dot = ColoredDot(color: UIColor(red: 0.32, green: 0.32, blue: 0.32, alpha: 1))
        contentView.addSubview(dot)
        dot.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18.0)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(12.0)
        }
        
        let textfield = UITextField()
        textfield.placeholder = "Name your recipe"
        contentView.addSubview(textfield)
        textfield.snp.makeConstraints {
            $0.leading.equalTo(dot.snp.trailing).offset(16.0)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        self.textfield = textfield
    }
}
