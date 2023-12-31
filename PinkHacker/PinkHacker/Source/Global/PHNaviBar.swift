//
//  PHNaviBar.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/20.
//

import UIKit
import SnapKit
import Then

public class PHNaviBar: UIView {

    public let leftButton = UIButton()
    public let titleLabel = UILabel()
    public let rightButton = UIButton()
    
    public enum BarItem {
        case back
        
        var icon: UIImage? {
            switch self {
            case .back: return .ic_back
            }
        }
    }
    
    public var title: String? {
        get { self.titleLabel.text }
        set {
            self.titleLabel.setText(
                newValue,
                attributes: .init(
                    weight: .gellix(.bold),
                    size: 20,
                    textColor: UIColor(red: 0.19, green: 0.19, blue: 0.19, alpha: 1)
                )
            )
            
        }
    }
    
    public var leftBarItem: BarItem? {
        didSet { self.leftIcon = leftBarItem?.icon }
    }
    
    public var rightBarItem: BarItem? {
        didSet { self.rightIcon = rightBarItem?.icon }
    }
    
    private var leftIcon: UIImage? {
        get { self.leftButton.image(for: .normal) }
        set { self.leftButton.setImage(newValue, for: .normal) }
    }
    
    private var rightIcon: UIImage? {
        get { self.rightButton.image(for: .normal) }
        set { self.rightButton.setImage(newValue, for: .normal) }
    }
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.setupAttribute()
        self.setupLayout()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupAttribute()
        self.setupLayout()
    }
    
    public override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 56)
    }
    
    private func setupAttribute() {
        self.titleLabel.do {
            $0.textColor = UIColor(red: 0.19, green: 0.19, blue: 0.19, alpha: 1)
            $0.font = .gellizFont(weight: .bold, size: 20)
        }
    }
    
    private func setupLayout() {
        self.addSubview(self.leftButton)
        self.leftButton.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(8)
        }
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.leading.equalTo(leftButton.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
        self.addSubview(self.rightButton)
        self.rightButton.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
        }
    }
}
