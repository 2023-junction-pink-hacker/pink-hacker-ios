//
//  OrderViewController.swift
//  PinkHacker
//
//  Created by 김가영 on 2023/08/19.
//

import UIKit
import Combine

private struct OrderSection: Hashable {
    let type: OrderSectionType
    let dotColor: UIColor?
    let title: String? // for Footer
    let count: Int? // for Footer
    let regardsFooterAsCell: Bool
    
    init(type: OrderSectionType, dotColor: UIColor? = nil, title: String? = nil, count: Int? = nil, regardsFooterAsCell: Bool = false) {
        self.type = type
        self.dotColor = dotColor
        self.title = title
        self.count = count
        self.regardsFooterAsCell = regardsFooterAsCell
    }
    
    var hasFooter: Bool {
        title != nil || count != nil
    }
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
        
        let colors: [UIColor] = [UIColor(red: 0.89, green: 0.82, blue: 0.63, alpha: 1),
                                 UIColor(red: 1, green: 0.52, blue: 0.37, alpha: 1),
                                 UIColor(red: 1, green: 0.85, blue: 0.47, alpha: 1),
                                 UIColor(red: 0.47, green: 0.77, blue: 0.5, alpha: 1)]
        
        var snapshot = Snapshot()
        sections.append(.init(type: .title))
        snapshot.appendSections([OrderSection(type: .title)])
        snapshot.appendItems([OrderTitleItem()])
        
        sections.append(.init(type: .multiSelection, dotColor: colors[0]))
        snapshot.appendSections([OrderSection(type: .multiSelection, dotColor: colors[0])])
        snapshot.appendItems([OrderMultiSelectionItem(description: "dough with", options: ["wheat", "grain"])])
        snapshot.appendItems([OrderMultiSelectionItem(description: "dough aa", options: ["wheat", "grain"])])
        
        sections.append(.init(type: .multiSelection, dotColor: colors[1], title: "Add sauce type"))
        snapshot.appendSections([OrderSection(type: .multiSelection, dotColor: colors[1], title: "Add sauce type")])
        snapshot.appendItems([OrderMultiSelectionItem(description: "thickness", options: ["1.5", "2.0", "2.5"])])
        dataSource.applySnapshotUsingReloadData(snapshot)

        sections.append(.init(type: .multiSelection, dotColor: colors[1], count: 5, regardsFooterAsCell: true))
        snapshot.appendSections([OrderSection(type: .multiSelection, dotColor: colors[2], count: 5)])
        snapshot.appendItems([OrderMultiSelectionItem(description: "cheese", options: ["1.5", "2.0", "2.5"])])
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
        
        collectionView.register(OrderMoreView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: OrderMoreView.reuseIdentifier)
        collectionView.register(OrderStepperFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: OrderStepperFooter.reuseIdentifier)
    }
    
    func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView) { [unowned self] collectionView, indexPath, item in
            if let section = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section] {
                switch section.type {
                case .title:
                    return collectionView.dequeueCell(OrderTitleViewCell.self, for: indexPath)!
                case .multiSelection:
                    let cell = collectionView.dequeueCell(OrderMultiSelectionCell.self, for: indexPath)
                    if let item = item as? OrderMultiSelectionItem {
                        let numberOfItems = collectionView.numberOfItems(inSection: indexPath.section)
                        let shouldCornerBottom = (numberOfItems - 1 == indexPath.item) && !section.regardsFooterAsCell
                        cell?.dot.backgroundColor = section.dotColor
                        cell?.apply(item, shouldCornerTop: indexPath.item == 0, shouldCornerBottom: shouldCornerBottom)
                        cell?.selectionButton.actionButton.pressHandler { [weak self] _ in
                            if let actionSheet = cell?.actionSheet {
                                self?.show(actionSheet, sender: nil)
                            }
                        }
                    }
                    return cell
                }
            }
            return collectionView.dequeueCell(UICollectionViewCell.self, for: indexPath)
        }
        dataSource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            let section = self.sections[indexPath.section]
            switch kind {
            case UICollectionView.elementKindSectionFooter:
                if let title = section.title {
                    let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: OrderMoreView.reuseIdentifier, for: indexPath)
                    if let footer = footer as? OrderMoreView {
                        footer.label.text = title
                        footer.actionButton.pressHandler { _ in
//                            var snapshot = self.dataSource.snapshot()
//                            snapshot.appendItems(<#T##identifiers: [AnyHashable]##[AnyHashable]#>)
                        }
                    }
                    return footer
                } else if let count = section.count {
                    let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: OrderStepperFooter.reuseIdentifier, for: indexPath)
                    if let footer = footer as? OrderStepperFooter {
                        footer.value = count
                    }
                    return footer
                }
                return nil
            default:
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
                    
                    if section.hasFooter {
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
