//
//  OrderMultiSelectionCell.swift
//  PinkHacker
//
//  Created by 김가영 on 2023/08/19.
//

import UIKit
import SnapKit

final class OrderMultiSelectionCell: UICollectionViewCell {
    
    var dot: ColoredDot!
    var selectionButton: RoundedSelectionButton!
    var descriptionLabel: UILabel!
    
    var topConstraints: Constraint?
    var bottomConstraints: Constraint?
    
    var maskedCorners: CACornerMask? {
        didSet {
            if let maskedCorners {
                layer.maskedCorners = maskedCorners
            }
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
        backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.93, alpha: 1)
        layer.cornerRadius = 10.0
        
        let selectionButton = RoundedSelectionButton()
        contentView.addSubview(selectionButton)
        selectionButton.snp.makeConstraints {
            topConstraints = $0.top.equalToSuperview().inset(12).constraint
            bottomConstraints = $0.bottom.equalToSuperview().inset(12).constraint
            $0.leading.equalToSuperview().inset(40.0)
            $0.width.equalTo(148.0)
        }
        self.selectionButton = selectionButton
        
        let descriptionLabel = UILabel(weight: .semibold, color: UIColor(red: 0.31, green: 0.31, blue: 0.29, alpha: 1))
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(selectionButton.snp.trailing).offset(8.0)
            $0.trailing.lessThanOrEqualToSuperview()
            $0.centerY.equalTo(selectionButton.label)
        }
        self.descriptionLabel = descriptionLabel
        
        let dot = ColoredDot()
        dot.isHidden = true
        contentView.addSubview(dot)
        dot.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18.0)
            $0.centerY.equalTo(selectionButton)
            $0.size.equalTo(12.0)
        }
        self.dot = dot
    }
    
    func apply(_ item: OrderMultiSelectionItem, shouldCornerTop: Bool = true, shouldCornerBottom: Bool = true) {
        descriptionLabel.text = item.description
        dot.isHidden = !shouldCornerTop
        
        if shouldCornerTop {
            maskedCorners = .top
            topConstraints?.update(inset: 18.0)
            bottomConstraints?.update(inset: 5.0)
        } else if shouldCornerBottom {
            maskedCorners = .bottom
            topConstraints?.update(inset: 5.0)
            bottomConstraints?.update(inset: 18.0)
        } else {
            maskedCorners = []
            topConstraints?.update(inset: 12.0)
            bottomConstraints?.update(inset: 12.0)
        }
    }
}

final class RoundedSelectionButton: UIView {
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 34.0)
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
        backgroundColor = UIColor(red: 0.92, green: 0.91, blue: 0.87, alpha: 1)
        
        let label = UILabel(weight: .semibold, color: UIColor(red: 0.76, green: 0.76, blue: 0.74, alpha: 1))
        label.textAlignment = .center
        label.text = "Selelct"
        addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: -4, left: 16.0, bottom: 0, right: 16))
        }
        self.label = label
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
    }
}

extension CACornerMask {
    static let top: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    static let bottom: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
}

