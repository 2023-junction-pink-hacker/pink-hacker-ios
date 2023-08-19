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
    private let naviBar = PHNaviBar(frame: .zero)
    private let titleLabel = UILabel()
    private let locationIconImageView = UIImageView()
    private let locationLabel = UILabel()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private let warningLabel = UILabel()
    private let orderButton = UIButton()
    
    private let dummies: [RestaurantCell.ViewModel] = [
        .init(name: "Branch Name 1", endTime: "17:25", address: "168-7, Chaseongdong-ro, Gijang-eup, Gijang-gun"),
        .init(name: "Branch Name 2", endTime: "17:37", address: "168-7, Chaseongdong-ro, Gijang-eup, Gijang-gun"),
        .init(name: "Branch Name 3", endTime: "18:20", address: "168-7, Chaseongdong-ro, Gijang-eup, Gijang-gun"),
    ]
    
    private var selectedRestaurant: RestaurantCell.ViewModel? {
        didSet {
            orderButton.isEnabled = (selectedRestaurant == nil) == false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttribute()
        setupLayout()
    }
    
    @objc private func didTapOrderButton() {
        guard let selectedRestaurant else { return }
        let viewController = OrderCompleteViewController(
            .init(
                pizzaName: selectedRestaurant.name,
                endTime: selectedRestaurant.endTime
            )
        )
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension RestaurantListViewController {
    private func setupAttribute() {
        naviBar.leftBarItem = .back
        naviBar.title = ""
        naviBar.leftButton.addTarget(self, action: #selector(didTapLeftButton), for: .touchUpInside)
        view.backgroundColor = Const.backgroundColor
        titleLabel.setText(Const.title, attributes: Const.titleAttributes)
        locationIconImageView.image = UIImage(systemName: "location.fill")
        locationIconImageView.tintColor =  Const.locationIconColor
        locationLabel.setText(
            "55, APEC-ro, Haeundae-gu",
            attributes: Const.locationAttributes
        )
        collectionView.do {
            $0.registerCell(RestaurantCell.self)
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 12
            layout.scrollDirection = .vertical
            let width = screenWidth - Const.collectionViewHorizontalInset * 2
            layout.itemSize = .init(width: width, height: 110)
            layout.sectionInset = .init(
                top: 10,
                left: Const.collectionViewHorizontalInset,
                bottom: 10,
                right: Const.collectionViewHorizontalInset
            )
            $0.allowsSelection = true
            $0.setCollectionViewLayout(layout, animated: false)
            $0.dataSource = self
            $0.delegate = self
            $0.backgroundColor = .clear
            $0.isScrollEnabled = true
        }
        let title = NSMutableAttributedString.build(string: "Order Food", attributes: Const.buttonTitleAttributes)
        orderButton.setAttributedTitle(title, for: .normal)
        orderButton.setBackgroundColor(Const.disabledButtonColor, for: .disabled)
        orderButton.setBackgroundColor(Const.enabledButtonColor, for: .normal)
        orderButton.layer.cornerRadius = 16
        orderButton.layer.masksToBounds = true
        orderButton.isEnabled = false
        orderButton.addTarget(self, action: #selector(didTapOrderButton), for: .touchUpInside)
        warningLabel.setText(Const.warning, attributes: Const.warningAttributes)
        warningLabel.numberOfLines = 2
        warningLabel.textAlignment = .center
        let backBarButton = UIBarButtonItem(
            image: .ic_back,
            style: .done,
            target: self,
            action: #selector(didTapBackButton)
        )
        self.navigationItem.backBarButtonItem = backBarButton
    }
    
    private func setupLayout() {
        view.addSubview(naviBar)
        view.addSubview(titleLabel)
        view.addSubview(locationLabel)
        view.addSubview(locationIconImageView)
        view.addSubview(collectionView)
        view.addSubview(warningLabel)
        view.addSubview(orderButton)
        
        naviBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(10)
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
            make.top.equalTo(locationLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(warningLabel.snp.top).offset(-15)
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
    
    @objc private func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension RestaurantListViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return dummies.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueCell(RestaurantCell.self, for: indexPath)
        else { return .init() }
        cell.configure(viewModel: dummies[indexPath.item])
        return cell
    }
}

extension RestaurantListViewController: UICollectionViewDelegate {
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let restaurant = dummies[safe: indexPath.item] else { return }
        selectedRestaurant = restaurant
    }
}

private extension RestaurantListViewController {
    enum Const {
        static let collectionViewHorizontalInset: CGFloat = 20
        static let title: String = "Select a restaurant near you"
        static let warning = "*Available restaurants\nwith your custom ingredients"
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
        static let warningAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.bold),
            size: 16,
            textColor: Const.warningColor
        )
        static let titleColor = UIColor(red: 0.19, green: 0.19, blue: 0.19, alpha: 1)
        static let locationTitleColor = UIColor(red: 0.31, green: 0.31, blue: 0.29, alpha: 1)
        static let locationIconColor = UIColor(red: 0.89, green: 0.82, blue: 0.63, alpha: 1)
        static let backgroundColor = UIColor(red: 0.99, green: 0.98, blue: 0.97, alpha: 1)
        static let disabledButtonColor = UIColor(red: 0.85, green: 0.84, blue: 0.84, alpha: 1)
        static let enabledButtonColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
        static let warningColor = UIColor(red: 1, green: 0.52, blue: 0.37, alpha: 1)
    }
}
