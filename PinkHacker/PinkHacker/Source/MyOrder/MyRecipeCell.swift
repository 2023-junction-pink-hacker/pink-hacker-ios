//
//  MyRecipeCell.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/20.
//

import Combine
import UIKit
import SnapKit
import Then

final class MyRecipeCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let button = UIButton()
    
    private let didTapButtonSubject = PassthroughSubject<Void, Never>()
    var didTapButtonPublisher: AnyPublisher<Void, Never> {
        didTapButtonSubject.eraseToAnyPublisher()
    }
    
    var bag = Set<AnyCancellable>()
    
    struct ViewModel: Hashable {
        var id: Int
        var title: String
        var subtitle: String
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAttribute()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapButton() {
        didTapButtonSubject.send(())
    }
    
    func configure(viewModel: ViewModel) {
        bag.removeAll()
        
        titleLabel.setText(viewModel.title, attributes: Const.titleAttributes)
        subtitleLabel.setText(viewModel.subtitle, attributes: Const.subtitleAttributes)
    }
}

extension MyRecipeCell {
    private func setupAttribute() {
        let title = NSMutableAttributedString.build(string: "Re-order", attributes: Const.buttonTitleAttributes)
        button.setAttributedTitle(title, for: .normal)
        button.contentEdgeInsets = .init(top: 8, left: 16, bottom: 10, right: 16)
        button.setBackgroundColor(Const.buttonBackgroundColor, for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = Const.backgroundColor
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(button)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.leading.equalToSuperview().offset(16)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(18)
        }
        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(96)
            make.height.equalTo(37)
        }
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
    }
}

private extension MyRecipeCell {
    enum Const {
        static let titleAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.semibold),
            size: 16,
            textColor: Const.titleColor
        )
        static let buttonTitleAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.semibold),
            size: 16,
            textColor: .white
        )
        static let subtitleAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.semibold),
            size: 13,
            textColor: Const.subtitleColor
        )
        static let subtitleColor = UIColor(red: 0.69, green: 0.69, blue: 0.68, alpha: 1)
        static let backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.93, alpha: 1)
        static let buttonBackgroundColor = UIColor(red: 0.19, green: 0.19, blue: 0.19, alpha: 1)
        static let titleColor = UIColor(red: 0.31, green: 0.31, blue: 0.29, alpha: 1)
    }
}
