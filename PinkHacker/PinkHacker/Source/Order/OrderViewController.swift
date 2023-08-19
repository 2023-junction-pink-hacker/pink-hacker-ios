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
    let count: Int? // for Footer
    
    init(type: OrderSectionType, dotColor: UIColor? = nil, count: Int? = nil) {
        self.type = type
        self.dotColor = dotColor
        self.count = count
    }
    
    var hasFooter: Bool {
        count != nil
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
        
        cancellable = OrderRequest(productId: 1).publisher().sink(receiveCompletion: { _ in },
                                          receiveValue: { response in
            self.loadData(steps: response.steps ?? [])
        })
    }
    
    private func loadData(steps: [OrderStepDataModel]) {
        
        var snapshot = Snapshot()
        
        sections.append(.init(type: .title))
        snapshot.appendSections([OrderSection(type: .title)])
        snapshot.appendItems([OrderTitleItem()])
        
        let colors: [UIColor] = [UIColor(red: 0.89, green: 0.82, blue: 0.63, alpha: 1),
                                 UIColor(red: 1, green: 0.52, blue: 0.37, alpha: 1),
                                 UIColor(red: 1, green: 0.85, blue: 0.47, alpha: 1),
                                 UIColor(red: 0.47, green: 0.77, blue: 0.5, alpha: 1)]
        
        steps.enumerated().forEach { (i, step) in
            let section = OrderSection(type: .multiSelection, dotColor: colors[i%colors.count])
            let items: [AnyHashable]? = step.options?.compactMap { option in
                switch option.type {
                case .SELECT, .PLAIN:
                    return OrderMultiSelectionItem(description: option.title ?? "", items: option.values ?? [])
                case.AMOUNT:
                    return OrderOptionalSelectionItem(description: option.title ?? "", count: option.values?.first.flatMap { Int($0.value) })
                case .AMOUNT_THIRD:
                    return OrderOptionalSelectionItem(description: option.title ?? "", items: option.values)
                default:
                    return nil
                }
            }
            if let items, !items.isEmpty {
                snapshot.appendSections([section])
                sections.append(section)
                snapshot.appendItems(items)
            }
        }
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
        collectionView.registerCell(OrderSimpleTitleCell.self)
        collectionView.registerCell(OrderCheckboxCell.self)
        
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
                    switch item {
                    case let item as OrderMultiSelectionItem:
                        if !item.options.isEmpty {
                            let cell = collectionView.dequeueCell(OrderMultiSelectionCell.self, for: indexPath)
                            let numberOfItems = collectionView.numberOfItems(inSection: indexPath.section)
                            let shouldCornerBottom = (numberOfItems - 1 == indexPath.item) && !section.hasFooter
                            cell?.dot.backgroundColor = section.dotColor
                            cell?.apply(item, shouldCornerTop: indexPath.item == 0, shouldCornerBottom: shouldCornerBottom)
                            cell?.selectionButton.actionButton.pressHandler { [weak self] _ in
                                if let actionSheet = cell?.actionSheet {
                                    self?.show(actionSheet, sender: nil)
                                }
                            }
                            return cell
                        } else {
                            let cell = collectionView.dequeueCell(OrderSimpleTitleCell.self, for: indexPath)
                            cell?.apply(item)
                            cell?.dot.backgroundColor = section.dotColor
                            return cell
                        }
                    case let item as OrderOptionalSelectionItem:
                        let cell = collectionView.dequeueCell(OrderCheckboxCell.self, for: indexPath)
                        let numberOfItems = collectionView.numberOfItems(inSection: indexPath.section)
                        cell?.apply(item, shouldCornerBottom: numberOfItems - 1 == indexPath.item)
                        cell?.selectionButton.actionButton.pressHandler { [weak self] _ in
                            if let actionSheet = cell?.actionSheet {
                                self?.show(actionSheet, sender: nil)
                            }
                        }
                        return cell
                    default:
                        break
                    }
                    
                }
            }
            return collectionView.dequeueCell(UICollectionViewCell.self, for: indexPath)
        }
        dataSource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            let section = self.sections[indexPath.section]
            switch kind {
            case UICollectionView.elementKindSectionFooter:
                if let count = section.count {
                    let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: OrderStepperFooter.reuseIdentifier, for: indexPath)
                    if let footer = footer as? OrderStepperFooter {
                        footer.stepper.value = count
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
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
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
    let items: [SimpleStringDataModel]
    var selectedItem: String?
    
    var options: [String] {
        items.map { $0.value }
    }
}

struct OrderOptionalSelectionItem: Hashable {
    let description: String
    var selected: Bool
    
    let items: [SimpleStringDataModel]?
    var selectedItem: String?
    
    var count: Int?
    
    var options: [String]? {
        items?.map { $0.value }
    }
    init(description: String, selected: Bool = false, items: [SimpleStringDataModel]? = nil, selectedItem: String? = nil, count: Int? = nil) {
        self.description = description
        self.selected = selected
        self.items = items
        self.selectedItem = selectedItem
        self.count = count
    }
}
