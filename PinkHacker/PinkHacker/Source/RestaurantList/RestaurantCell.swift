//
//  RestaurantCell.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/19.
//

import UIKit
import SnapKit
import Then

final class RestaurantCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let timeImageView = UIImageView()
    private let timeLabel = UILabel()
    private let addressLabel = UILabel()
    
    struct ViewModel {
        var name: String
        var endTime: String
        var address: String
    }
    
    override var isSelected: Bool {
        didSet {
            let borderColor: UIColor? = isSelected ? Const.selectedBorderColor : nil
            let borderWidth: CGFloat = isSelected ? 3 : 0
            self.contentView.layer.borderColor = borderColor?.cgColor
            self.contentView.layer.borderWidth = borderWidth
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAttribute()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: ViewModel) {
        titleLabel.setText(viewModel.name, attributes: Const.titleAttributes)
        timeLabel.setText("\(viewModel.time ?? "00:00 am")", attributes: Const.timeAttributes)
        addressLabel.setText(viewModel.address, attributes: Const.addressAttributes)
    }
}

extension RestaurantCell {
    private func setupAttribute() {
        let font = UIFont.boldSystemFont(ofSize: 15)
        let configuration = UIImage.SymbolConfiguration.init(font: font)
        timeImageView.image = .init(systemName: "timer")?.withConfiguration(configuration)
        timeImageView.tintColor = Const.timeIconColor
        contentView.backgroundColor = Const.backgroundColor
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        addressLabel.numberOfLines = 2
        addressLabel.lineBreakMode = .byCharWrapping
    }
    
    private func setupLayout() {
        let containerView = setupContainerView()
        
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(22)
        }
    }
    
    private func setupContainerView() -> UIView {
        let containerView = UIView()
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(timeImageView)
        containerView.addSubview(timeLabel)
        containerView.addSubview(addressLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(19)
        }
        timeImageView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing)
            make.firstBaseline.equalTo(timeLabel)
        }
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeImageView.snp.trailing).offset(2)
            make.firstBaseline.equalTo(titleLabel)
            make.trailing.equalToSuperview()
        }
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalToSuperview()
        }
        return containerView
    }
}

extension RestaurantCell.ViewModel {
    var time: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let date = dateFormatter.date(from: self.endTime) {
            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.locale = .init(identifier: "en")
            return dateFormatter.string(from: date)
        }
        return nil
    }
}

private extension RestaurantCell {
    enum Const {
        static let titleAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.bold),
            size: 18,
            textColor: Const.titleColor
        )
        static let timeAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.bold),
            size: 16,
            textColor: Const.timeColor
        )
        static let addressAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.semibold),
            size: 15,
            textColor: Const.addressColor
        )
        static let titleColor = UIColor(red: 0.31, green: 0.31, blue: 0.29, alpha: 1)
        static let timeColor = UIColor(red: 1, green: 0.52, blue: 0.37, alpha: 1)
        static let timeIconColor = UIColor(red: 1, green: 0.68, blue: 0.58, alpha: 1)
        static let addressColor = UIColor(red: 0.69, green: 0.69, blue: 0.64, alpha: 1)
        static let backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.93, alpha: 1)
        static let selectedBorderColor = UIColor(red: 1, green: 0.68, blue: 0.58, alpha: 1)
    }
}
