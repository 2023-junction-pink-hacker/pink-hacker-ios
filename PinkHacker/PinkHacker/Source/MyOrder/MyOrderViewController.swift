//
//  MyOrderViewController.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/20.
//

import UIKit
import SnapKit
import Then

final class MyOrderViewController: UIViewController {
    typealias Section = MyOrderSection
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Section.Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Section.Item>
    
    private let titleLabel = UILabel()
    private let headerView = MyOrderHeaderView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private lazy var dataSource = dataSource(of: collectionView)
    
    private var sections: [Section] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttribute()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applySections([
            .init(type: .recent, items: [
                .myRecent(.init(id: 0, title: "Tuesday Pizza", subtitle: "08.20 FRI")),
                .myRecent(.init(id: 1, title: "Special Combo Combo", subtitle: "06.12 SAT"))
            ]),
            .init(type: .recipe, items: [
                .myRecipe(.init(id: 0, title: "Wednesday Pizza", subtitle: "80 orders")),
                .myRecipe(.init(id: 1, title: "Wednesday Pizza", subtitle: "80 orders")),
                .myRecipe(.init(id: 2, title: "Wednesday Pizza", subtitle: "80 orders"))
            ])
        
        ])
    }
    
    func dataSource(of collectionView: UICollectionView) -> DataSource {
        DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, item in
                guard let self else { return nil }
                switch item {
                case let .myRecent(viewModel):
                    guard let cell = collectionView.dequeueCell(RecentOrderCell.self, for: indexPath)
                    else { return nil }
                    cell.configure(viewModel: viewModel)
                    cell.didTapButtonPublisher
                        .sink { _ in
                            guard let item = self.sections[safe: indexPath.section]?.items[safe: indexPath.item],
                                  case let .myRecent(viewModel) = item
                            else { return }
                            let registerViewController = RegisterViewController(viewModel: .init(recipeId: viewModel.id, pizzaName: viewModel.title))
                            self.navigationController?.pushViewController(registerViewController, animated: true)
                        }
                        .store(in: &cell.bag)
                    return cell
                case let .myRecipe(viewModel):
                    guard let cell = collectionView.dequeueCell(MyRecipeCell.self, for: indexPath)
                    else { return nil }
                    cell.configure(viewModel: viewModel)
                    cell.didTapButtonPublisher
                        .sink { _ in
                            guard let item = self.sections[safe: indexPath.section]?.items[safe: indexPath.item],
                                  case let .myRecipe(viewModel) = item
                            else { return }
                            let restarauntViewController = RestaurantListViewController()
                            self.navigationController?.pushViewController(restarauntViewController, animated: true)
                        }
                        .store(in: &cell.bag)
                    return cell
                }
            },
            supplementaryViewProvider: { [weak self] collectionView, elementKind, indexPath in
                guard let section = self?.sections[safe: indexPath.section] else { return .init() }
                guard let header = collectionView.dequeueSupplementaryView(MyOrderTitleHeaderView.self, for: indexPath)
                else { return nil }
                header.configure(title: section.type.headerTitle)
                return header
            }
        )
    }
    
    private func applySections(_ sections: [Section]) {
        self.sections = sections
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach { snapshot.appendItems($0.items, toSection: $0) }
        dataSource.apply(snapshot)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return .init { section, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.estimated(76)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 12
            section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(62)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        }.then {
            let configuration = UICollectionViewCompositionalLayoutConfiguration()
            configuration.scrollDirection = .vertical
            $0.configuration = configuration
        }
    }
}

extension MyOrderViewController {
    private func setupAttribute() {
        collectionView.do {
            $0.registerCell(RecentOrderCell.self)
            $0.registerCell(MyRecipeCell.self)
            $0.registerSupplementaryView(MyOrderTitleHeaderView.self)
            $0.setCollectionViewLayout(createLayout(), animated: false)
            $0.backgroundColor = Const.backgroundColor
            $0.contentInset = .init(top: 0, left: 0, bottom: 20, right: 0)
        }
        view.backgroundColor = Const.backgroundColor
        titleLabel.setText("My Order", attributes: Const.titleAttributes)
        headerView.configure(
            viewModel: .init(
                name: "I hate monday Pizza",
                progress: .cooking,
                endTime: "3:00"
            )
        )
    }
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(headerView)
        view.addSubview(collectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.leading.equalToSuperview().offset(24)
        }
        headerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(44)
            make.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(32)
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

private extension MyOrderViewController {
    enum Const {
        static let titleAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.bold),
            size: 28,
            textColor: Const.titleColor
        )
        static let titleColor = UIColor(red: 0.19, green: 0.19, blue: 0.19, alpha: 1)
        static let backgroundColor = UIColor(red: 0.99, green: 0.98, blue: 0.97, alpha: 1)
    }
}

extension UICollectionViewDiffableDataSource {
    public convenience init(
        collectionView: UICollectionView,
        cellProvider: @escaping CellProvider,
        supplementaryViewProvider: @escaping SupplementaryViewProvider
    ) {
        self.init(collectionView: collectionView, cellProvider: cellProvider)
        self.supplementaryViewProvider = supplementaryViewProvider
    }
}
