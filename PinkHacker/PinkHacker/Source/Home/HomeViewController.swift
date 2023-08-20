//
//  HomeViewController.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/20.
//

import UIKit
import SnapKit
import Then

final class HomeViewController: UIViewController {
    private let titleLabel = UILabel()
    private let likedButton = UIButton()
    private let latestButton = UIButton()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: screenWidth - 50, height: 100)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.contentInset = .init(top: 5, left: 25, bottom: 10, right: 25)
        view.registerCell(FeedCell.self)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        return view
    }()
    
    private var dummies: [FeedCell.ViewModel] {
        [
            .init(id: 0, orderCount: 200, imageUrl: "", title: "I hate monday Pizza", content: "Hand-tossed crust, tangy sauce, melted mozzarella, and pepperoni slices create a timeless favorite"),
            .init(id: 1, orderCount: 200, imageUrl: "", title: "I hate monday Pizza", content: "Hand-tossed crust, tangy"),
            .init(id: 2, orderCount: 200, imageUrl: "", title: "I hate monday Pizza", content: "Hand-tossed crust, tangy sauce, melted mozzarella, and pepperoni slices create a timeless favorite")
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttribute()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }
    
    @objc private func didTapLikedButton() {
        guard likedButton.isSelected == false else { return }
        self.likedButton.isSelected = self.likedButton.isSelected == false
        self.latestButton.isSelected = self.latestButton.isSelected == false
    }
    
    @objc private func didTapLatestedButton() {
        guard latestButton.isSelected == false else { return }
        self.likedButton.isSelected = self.likedButton.isSelected == false
        self.latestButton.isSelected = self.latestButton.isSelected == false
    }
}

extension HomeViewController {
    private func setupAttribute() {
        view.backgroundColor = Const.backgroundColor
        titleLabel.setText("Recipes", attributes: Const.titleAttributes)
        likedButton.setImage(.ic_love.withTintColor(Const.selectedColor), for: .highlighted)
        likedButton.setImage(.ic_love.withTintColor(Const.selectedColor), for: .selected)
        likedButton.setImage(.ic_love.withTintColor(Const.unselectedColor), for: .normal)
        likedButton.setTitle("most loved", for: .normal)
        likedButton.setTitleColor(Const.selectedTitleColor, for: .selected)
        likedButton.setTitleColor(Const.selectedTitleColor, for: .highlighted)
        likedButton.setTitleColor(Const.unselectedColor, for: .normal)
        likedButton.isSelected = true
        likedButton.setBackgroundColor(Const.unselectedBackgroundColor, for: .normal)
        likedButton.setBackgroundColor(Const.selectedBackgroundColor, for: .selected)
        likedButton.setBackgroundColor(Const.selectedBackgroundColor, for: .highlighted)
        likedButton.contentEdgeInsets = .init(top: 6, left: 16, bottom: 6, right: 16)
        likedButton.titleEdgeInsets = .init(top: 0, left: 4, bottom: 0, right: -4)
        likedButton.imageEdgeInsets = .init(top: 0, left: -4, bottom: 0, right: 4)
        likedButton.addTarget(self, action: #selector(didTapLikedButton), for: .touchUpInside)
        likedButton.layer.cornerRadius = 12
        likedButton.layer.masksToBounds = true
        latestButton.setImage(.ic_time_home.withTintColor(Const.selectedColor), for: .highlighted)
        latestButton.setImage(.ic_time_home.withTintColor(Const.selectedColor), for: .selected)
        latestButton.setImage(.ic_time_home.withTintColor(Const.unselectedColor), for: .normal)
        latestButton.setTitle("latest", for: .normal)
        latestButton.setTitleColor(Const.selectedTitleColor, for: .selected)
        latestButton.setTitleColor(Const.selectedTitleColor, for: .highlighted)
        latestButton.setTitleColor(Const.unselectedColor, for: .normal)
        latestButton.setBackgroundColor(Const.unselectedBackgroundColor, for: .normal)
        latestButton.setBackgroundColor(Const.selectedBackgroundColor, for: .selected)
        latestButton.setBackgroundColor(Const.selectedBackgroundColor, for: .highlighted)
        latestButton.contentEdgeInsets = .init(top: 6, left: 16, bottom: 6, right: 16)
        latestButton.titleEdgeInsets = .init(top: 0, left: 4, bottom: 0, right: -4)
        latestButton.imageEdgeInsets = .init(top: 0, left: -4, bottom: 0, right: 4)
        latestButton.addTarget(self, action: #selector(didTapLatestedButton), for: .touchUpInside)
        latestButton.layer.cornerRadius = 12
        latestButton.layer.masksToBounds = true
    }
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(likedButton)
        view.addSubview(latestButton)
        view.addSubview(collectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.leading.equalToSuperview().offset(24)
        }
        likedButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.leading.equalToSuperview().inset(21)
            make.height.equalTo(34)
        }
        latestButton.snp.makeConstraints { make in
            make.leading.equalTo(likedButton.snp.trailing).offset(8)
            make.verticalEdges.equalTo(likedButton)
            make.height.equalTo(34)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(likedButton.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueCell(FeedCell.self, for: indexPath) else { return .init() }
        cell.configure(viewModel: dummies[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dummies[safe: indexPath.item] else { return }
        let orderViewController = OrderViewController(viewType: .old(recipeName: item.title))
        orderViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(orderViewController, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let item = dummies[safe: indexPath.item] else { return .zero }
        let height = FeedCell.height(item)
        return .init(width: screenWidth - 50, height: height)
    }
}

private extension HomeViewController {
    enum Const {
        static let titleAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.bold),
            size: 28,
            textColor: Const.titleColor
        )
        static let titleColor = UIColor(red: 0.19, green: 0.19, blue: 0.19, alpha: 1)
        static let backgroundColor = UIColor(red: 0.99, green: 0.98, blue: 0.97, alpha: 1)
        static let selectedColor = UIColor(red: 1, green: 0.52, blue: 0.37, alpha: 1)
        static let unselectedColor = UIColor(red: 0.69, green: 0.69, blue: 0.68, alpha: 1)
        static let selectedTitleColor = UIColor(red: 0.31, green: 0.31, blue: 0.29, alpha: 1)
        static let selectedBackgroundColor = UIColor(red: 1, green: 0.93, blue: 0.9, alpha: 1)
        static let unselectedBackgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.93, alpha: 1)
    }
}
