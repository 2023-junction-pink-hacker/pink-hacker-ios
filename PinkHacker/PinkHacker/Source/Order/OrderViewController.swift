//
//  OrderViewController.swift
//  PinkHacker
//
//  Created by 김가영 on 2023/08/19.
//

import UIKit
import Combine

class OrderViewController: UIViewController {
    
    fileprivate enum OrderSection: Int {
        case title
        case multiSelection
    }
    
    var cancellable: AnyCancellable?
    
    private var collectionView: UICollectionView!
    private var dataSource: DataSource!
    private var sections: [OrderSection] = []
    
    enum Section: Int {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Const.backgroundColor
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.collectionView = collectionView
        
        configureCollectionView()
        configureDataSource()
        
        cancellable = TestAPIRequest().publisher().sink(receiveCompletion: { _ in },
                                          receiveValue: { _ in
            //
        })
        self.loadData()
    }
    
    private func loadData() {
        var snapshot = Snapshot()
        sections.append(.title)
        snapshot.appendSections([.title])
        snapshot.appendItems([OrderTitleItem()])
        
        sections.append(.multiSelection)
        snapshot.appendSections([.multiSelection])
        snapshot.appendItems([OrderMultiSelectionItem(description: "dough with", options: ["wheat", "grain"])])
        snapshot.appendItems([OrderMultiSelectionItem(description: "thickness", options: ["1.5", "2.0", "2.5"])])
        dataSource.applySnapshotUsingReloadData(snapshot)

    }
}

// UICollectionView
private extension OrderViewController {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<OrderSection, AnyHashable>
    typealias DataSource = UICollectionViewDiffableDataSource<OrderSection, AnyHashable>
    
    func configureCollectionView() {
        collectionView.registerCell(UICollectionViewCell.self)
        collectionView.registerCell(OrderTitleViewCell.self)
        collectionView.registerCell(OrderMultiSelectionCell.self)
    }
    
    func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView) { [unowned self] collectionView, indexPath, item in
            if let section = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section] {
                switch section {
                case .title:
                    return collectionView.dequeueCell(OrderTitleViewCell.self, for: indexPath)!
                case .multiSelection:
                    let cell = collectionView.dequeueCell(OrderMultiSelectionCell.self, for: indexPath)
                    if let item = item as? OrderMultiSelectionItem {
                        let numberOfItems = collectionView.numberOfItems(inSection: indexPath.section)
                        cell?.apply(item, at: indexPath, numberOfItemsInSection: numberOfItems)
                    }
                    return cell
                }
            }
            return collectionView.dequeueCell(UICollectionViewCell.self, for: indexPath)
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
            UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                let sectionInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20)
                let section = self.sections[sectionIndex]
                switch section {
                case .title, .multiSelection:
                    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(OrderTitleViewCell.height))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = sectionInsets
                    return section
                }
            }
        }
}

private extension OrderViewController {
    enum Const {
        static let backgroundColor = UIColor(red: 0.99, green: 0.98, blue: 0.97, alpha: 1.0)
    }
}

struct OrderTitleItem: Hashable {
    var title: String?
}

struct OrderMultiSelectionItem: Hashable {
    let description: String
    let options: [String]
    var selectedItem: String?
}
