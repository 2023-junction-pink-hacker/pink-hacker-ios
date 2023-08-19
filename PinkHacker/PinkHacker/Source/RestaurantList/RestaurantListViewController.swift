//
//  RestaurantListViewController.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/19.
//

import UIKit
import SnapKit
import Then

final class RestaurantListViewController: UIViewController {
    private let titleLabel = UILabel()
    private let locationIconImageView = UIImageView()
    private let locationLabel = UILabel()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private let warningLabel = UILabel()
    private let orderButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttribute()
        setupLayout()
    }
    
    @objc private func didTapOrderButton() {
        
    }
}

extension RestaurantListViewController {
    private func setupAttribute() {
        view.backgroundColor = Const.backgroundColor
        titleLabel.setText(Const.title, attributes: Const.titleAttributes)
        locationIconImageView.image = UIImage(systemName: "location.fill")
        locationIconImageView.tintColor =  Const.locationIconColor
        locationLabel.setText(
            "55, APEC-ro, Haeundae-gu",
            attributes: Const.locationAttributes
        )
        collectionView.backgroundColor = .black
        let title = NSMutableAttributedString.build(string: "Order Food", attributes: Const.buttonTitleAttributes)
        orderButton.setAttributedTitle(title, for: .normal)
        orderButton.setBackgroundColor(Const.disabledButtonColor, for: .disabled)
        orderButton.setBackgroundColor(Const.enabledButtonColor, for: .normal)
        orderButton.layer.cornerRadius = 16
        orderButton.layer.masksToBounds = true
        orderButton.isEnabled = false
        orderButton.addTarget(self, action: #selector(didTapOrderButton), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(locationLabel)
        view.addSubview(locationIconImageView)
        view.addSubview(collectionView)
        view.addSubview(warningLabel)
        view.addSubview(orderButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
        }
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        locationIconImageView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(locationLabel)
            make.trailing.equalTo(locationLabel.snp.leading).offset(-8)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(warningLabel.snp.top).offset(-25)
        }
        warningLabel.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(21)
            make.bottom.equalTo(orderButton.snp.top).offset(-24)
        }
        orderButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(48)
            make.directionalHorizontalEdges.equalToSuperview().inset(21)
            make.height.equalTo(57)
        }
    }
}

private extension RestaurantListViewController {
    enum Const {
        static let title: String = "Select a restaurant near you"
        static let titleAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.bold),
            size: 24,
            textColor: Const.titleColor
        )
        static let locationAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.semibold),
            size: 18,
            textColor: Const.locationTitleColor
        )
        static let buttonTitleAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.semibold),
            size: 19,
            textColor: .white
        )
        static let titleColor = UIColor(red: 0.19, green: 0.19, blue: 0.19, alpha: 1)
        static let locationTitleColor = UIColor(red: 0.31, green: 0.31, blue: 0.29, alpha: 1)
        static let locationIconColor = UIColor(red: 0.89, green: 0.82, blue: 0.63, alpha: 1)
        static let backgroundColor = UIColor(red: 0.99, green: 0.98, blue: 0.97, alpha: 1)
        static let warning = "*Available restaurants\nwith your custom ingredients"
        static let disabledButtonColor = UIColor(red: 0.85, green: 0.84, blue: 0.84, alpha: 1)
        static let enabledButtonColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
    }
}
