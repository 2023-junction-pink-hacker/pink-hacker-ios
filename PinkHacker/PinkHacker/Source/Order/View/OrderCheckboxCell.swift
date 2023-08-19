//
//  OrderCheckboxCell.swift
//  PinkHacker
//
//  Created by 김가영 on 2023/08/20.
//

import UIKit
import SnapKit

final class OrderCheckboxCell: UICollectionViewCell {
    
    var checkboxButton: UIButton!
    var label: UILabel!
    var stepper: StepperView!
    
    var bottomConstraint: Constraint?
    
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
        
        let stackView = UIStackView()
        stackView.alignment = .center
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 44, bottom: 20, right: 18))
        }
        
        let checkboxButton = UIButton()
        checkboxButton.setContentHuggingPriority(.required, for: .horizontal)
        checkboxButton.setImage(UIImage(named: "ic_check_circle"), for: .normal)
        checkboxButton.setImage(UIImage(named: "ic_check_checked"), for: .selected)
        stackView.addArrangedSubview(checkboxButton)
        self.checkboxButton = checkboxButton
        
        stackView.setCustomSpacing(8, after: checkboxButton)
        
        let label = UILabel(weight: .medium, color: .label0)
        stackView.addArrangedSubview(label)
        self.label = label
        
        let stepper = StepperView()
        stackView.addArrangedSubview(stepper)
        stepper.setContentHuggingPriority(.required, for: .horizontal)
        self.stepper = stepper
    }
    
    func apply(_ item: OrderOptionalSelectionItem, shouldCornerBottom: Bool = false) {
        label.text = item.description
        stepper.value = item.count ?? 0
        stepper.enabled = checkboxButton.isSelected
        
        if shouldCornerBottom {
            layer.maskedCorners = .bottom
        } else {
            layer.maskedCorners = []
        }
        
        checkboxButton.pressHandler { [weak self] _ in
            guard let self else { return }
            checkboxButton.isSelected.toggle()
            stepper.enabled = checkboxButton.isSelected
        }
    }
}
