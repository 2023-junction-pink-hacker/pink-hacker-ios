//
//  OrderMoreView.swift
//  PinkHacker
//
//  Created by 김가영 on 2023/08/20.
//

import UIKit

final class OrderMoreView: UICollectionReusableView {
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 54)
    }
    
    var label: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        
        layer.cornerRadius = 10.0
        backgroundColor = UIColor(red: 0.92, green: 0.91, blue: 0.87, alpha: 1)
        
        let stackView = UIStackView()
        stackView.alignment = .firstBaseline
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        let imageView = UIImageView(image: UIImage(named: "ic_plus_clear"))
        stackView.addArrangedSubview(imageView)
        
        let label = UILabel(weight: .semibold, color: .label0)
        stackView.addArrangedSubview(label)
        self.label = label
    }
}

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}
