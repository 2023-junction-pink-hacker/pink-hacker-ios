//
//  OrderStepperFooter.swift
//  PinkHacker
//
//  Created by 김가영 on 2023/08/20.
//

import UIKit

final class OrderStepperFooter: UICollectionReusableView {
    
    var label: UILabel!
    
    var value = 0 {
        didSet {
            value = max(0, value)
            label.text = "\(value)"
        }
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
        
        layer.cornerRadius = 10.0
        backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.93, alpha: 1)
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.trailing.top.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 18, right: 18))
            $0.width.greaterThanOrEqualTo(112)
        }
        
        let minusButton = UIButton(type: .system)
        minusButton.setContentHuggingPriority(.required, for: .horizontal)
        minusButton.setImage(UIImage(named: "ic_minus_circle"), for: .normal)
        stackView.addArrangedSubview(minusButton)
        
        let label = UILabel(weight: .semibold, color: .label0)
        label.textAlignment = .center
        stackView.addArrangedSubview(label)
        self.label = label
        
        let plusButton = UIButton(type: .system)
        minusButton.pressHandler { [weak self] _ in
            self?.value -= 1
        }
        plusButton.pressHandler { [weak self] _ in
            self?.value += 1
        }
        plusButton.setContentHuggingPriority(.required, for: .horizontal)
        plusButton.setImage(UIImage(named: "ic_plus_circle"), for: .normal)
        stackView.addArrangedSubview(plusButton)
    }
}
