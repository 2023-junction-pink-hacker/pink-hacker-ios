//
//  OrderViewController.swift
//  PinkHacker
//
//  Created by 김가영 on 2023/08/19.
//

import UIKit
import Combine

private struct OrderSection {
    let type: OrderSectionType
    let title: String?
}

private enum OrderSectionType: Int {
    case title
    case multiSelection
}

class OrderViewController: UIViewController {
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
        sections.append(.init(type: .title, title: nil))
        snapshot.appendSections([.title])
        snapshot.appendItems([OrderTitleItem()])
        
        sections.append(.init(type: .multiSelection, title: "Add sauce type"))
        snapshot.appendSections([.multiSelection])
        snapshot.appendItems([OrderMultiSelectionItem(description: "dough with", options: ["wheat", "grain"])])
        snapshot.appendItems([OrderMultiSelectionItem(description: "thickness", options: ["1.5", "2.0", "2.5"])])
        dataSource.applySnapshotUsingReloadData(snapshot)

    }
}

// UICollectionView
private extension OrderViewController {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<OrderSectionType, AnyHashable>
    typealias DataSource = UICollectionViewDiffableDataSource<OrderSectionType, AnyHashable>
    
    func configureCollectionView() {
        collectionView.registerCell(UICollectionViewCell.self)
        collectionView.registerCell(OrderTitleViewCell.self)
        collectionView.registerCell(OrderMultiSelectionCell.self)
        
        collectionView.register(OrderMoreView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: OrderMoreView.reuseIdentifier)
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
        dataSource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            let section = self.sections[indexPath.section]
            
            if section.type == .multiSelection,
               kind == UICollectionView.elementKindSectionFooter {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: OrderMoreView.reuseIdentifier, for: indexPath)
                if let footer = footer as? OrderMoreView {
                    footer.label.text = section.title
                }
                return footer
            } else {
                return nil
            }
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
            UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                let sectionInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20)
                let section = self.sections[sectionIndex]
                switch section.type {
                case .title, .multiSelection:
                    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(OrderTitleViewCell.height))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    let sectionLayout = NSCollectionLayoutSection(group: group)
                    sectionLayout.contentInsets = sectionInsets
                    
                    if section.type == .multiSelection {
                        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(54)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
                        sectionLayout.boundarySupplementaryItems = [footer]
                    }
                    return sectionLayout
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
