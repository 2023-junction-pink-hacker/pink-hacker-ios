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
    var selectionButton: SmallSelectionButton!
    
    var bottomConstraint: Constraint?
    
    var actionSheet: UIAlertController?
    
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
        
        let selectionButton = SmallSelectionButton()
        selectionButton.isHidden = true
        stackView.addArrangedSubview(selectionButton)
        self.selectionButton = selectionButton
    }
    
    func apply(_ item: OrderOptionalSelectionItem, shouldCornerBottom: Bool = false) {
        
        if !item.description.isEmpty {
            label.text = item.description
            checkboxButton.isHidden = false
        } else {
            checkboxButton.isHidden = true
            checkboxButton.isSelected = true
        }
        
        if let count = item.count {
            stepper.isHidden = false
            selectionButton.isHidden = true
            stepper.value = count
            stepper.enabled = checkboxButton.isSelected
        } else {
            stepper.isHidden = true
            selectionButton.isHidden = false
            selectionButton.enabled = checkboxButton.isSelected
            selectionButton.label.text = item.options?.first ?? ""
        }
        
        if shouldCornerBottom {
            layer.maskedCorners = .bottom
        } else {
            layer.maskedCorners = []
        }
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        item.options?.forEach { option in
            actionSheet.addAction(UIAlertAction(title: option, style: .default) { [weak self] _ in
                self?.selectionButton.label.text = option
            })
        }
        self.actionSheet = actionSheet
        
        checkboxButton.pressHandler { [weak self] _ in
            guard let self else { return }
            checkboxButton.isSelected.toggle()
            stepper.enabled = checkboxButton.isSelected
            selectionButton.enabled = checkboxButton.isSelected
        }
    }
}

final class SmallSelectionButton: UIView {
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 112, height: 29)
    }
    
    var label: UILabel!
    var arrowButton: UIButton!
    var actionButton: UIButton!

    var enabled: Bool = false {
        didSet {
            label.textColor = enabled ? .label0 : UIColor(red: 0.76, green: 0.76, blue: 0.74, alpha: 1)
            arrowButton.isEnabled = enabled
            backgroundColor = enabled ? UIColor(red: 1, green: 1, blue: 0.96, alpha: 1) : UIColor(red: 0.93, green: 0.93, blue: 0.9, alpha: 1)
            actionButton.isEnabled = enabled
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
        let stackView = UIStackView()
        stackView.alignment = .lastBaseline
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 15))
        }
        
        let label = UILabel(weight: .semibold, color: .label0)
        label.textAlignment = .center
        label.baselineAdjustment = .alignBaselines
        stackView.addArrangedSubview(label)
        self.label = label
        
        let arrowButton = UIButton()
        arrowButton.setContentHuggingPriority(.required, for: .horizontal)
        arrowButton.setImage(UIImage(named: "ic_arrow_bottom_enabled"), for: .normal)
        arrowButton.setImage(UIImage(named: "ic_arrow_bottom"), for: .disabled)
        stackView.addArrangedSubview(arrowButton)
        self.arrowButton = arrowButton
        
        let actionButton = SizelessButton()
        addSubview(actionButton)
        actionButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.actionButton = actionButton
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
    }
    
    func apply() {
        enabled = true
    }
}
