//
//  OrderSimpleTitleCell.swift
//  PinkHacker
//
//  Created by 김가영 on 2023/08/20.
//

import UIKit

final class OrderSimpleTitleCell: UICollectionViewCell {
    
    var dot: ColoredDot!
    var descriptionLabel: UILabel!

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
        layer.cornerRadius = 10
        
        let dot = ColoredDot()
        contentView.addSubview(dot)
        dot.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(23)
            $0.size.equalTo(12.0)
        }
        self.dot = dot
        
        let descriptionLabel = UILabel(weight: .semibold, color: UIColor(red: 0.31, green: 0.31, blue: 0.29, alpha: 1))
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.lastBaseline.equalTo(dot)
            $0.leading.equalTo(dot.snp.trailing).offset(16)
        }
        self.descriptionLabel = descriptionLabel
        
        
    }
    
    func apply(_ item: OrderMultiSelectionItem) {
        layer.maskedCorners = .top
        descriptionLabel.text = item.description
    }
}
