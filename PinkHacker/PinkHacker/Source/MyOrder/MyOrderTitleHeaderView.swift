//
//  MyOrderTitleHeaderView.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/20.
//

import UIKit
import SnapKit
import Then

final class MyOrderTitleHeaderView: UICollectionReusableView {
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String?) {
        titleLabel.setText(title, attributes: Const.titleAttributes)
    }
    
    enum Const {
        static let titleAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.bold),
            size: 22,
            textColor: UIColor(red: 0.19, green: 0.19, blue: 0.19, alpha: 1)
        )
    }
}
