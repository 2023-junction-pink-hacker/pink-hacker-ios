//
//  OrderViewController.swift
//  PinkHacker
//
//  Created by 김가영 on 2023/08/19.
//

import UIKit
import Combine
import SnapKit

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
    
    private var naviBar = PHNaviBar(frame: .zero)
    private var collectionView: UICollectionView!
    private var dataSource: DataSource!
    private var sections: [OrderSection] = []
    private var bottomBar: UIView!
    private var doneButton: UIButton!
    
    private var isTitleEmpty = true {
        didSet {
            doneButton.isEnabled = selected >= 5 && !isTitleEmpty
            doneButton.backgroundColor = doneButton.isEnabled ? .label0 : UIColor(red: 0.85, green: 0.84, blue: 0.84, alpha: 1)
        }
    }
    private var result = SubmissionRequestDataModel()
    private var selected: Int = 0 {
        didSet {
            doneButton.isEnabled = selected >= 5 && !isTitleEmpty
            doneButton.backgroundColor = doneButton.isEnabled ? .label0 : UIColor(red: 0.85, green: 0.84, blue: 0.84, alpha: 1)
        }
    }
    
    enum Section: Int {
        case main
    }
    
    enum ViewType {
        case new
        case old(recipeName: String)
    }

    let viewType: ViewType
    
    init(viewType: ViewType) {
        self.viewType = viewType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Const.backgroundColor
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.addSubview(naviBar)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        self.collectionView = collectionView
        collectionView.keyboardDismissMode = .onDrag
        naviBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        collectionView.backgroundColor = .clear
        naviBar.leftBarItem = .back
        naviBar.leftButton.addTarget(self, action: #selector(didTapLeftButton), for: .touchUpInside)
        if case let .old(name) = viewType {
            naviBar.title = name
        } else {
            naviBar.title = "Order your own Recipe"
        }
        
        let bottomBarButton = UIButton()
        bottomBarButton.backgroundColor = UIColor(red: 0.85, green: 0.84, blue: 0.84, alpha: 1)
        view.addSubview(bottomBarButton)
        bottomBarButton.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(91.0)
            
        }
        bottomBarButton.pressHandler { [weak self] _ in
            self?.navigationController?.pushViewController(RestaurantListViewController(), animated: true)
        }
        self.doneButton = bottomBarButton
        bottomBarButton.isEnabled = false
        configureCollectionView()
        configureDataSource()
        
        let label = UILabel(weight: .semibold, size: 19, color: .white)
        bottomBarButton.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(17)
        }
        label.text = "Done"
        
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
    
    @objc private func didTapLeftButton() {
        navigationController?.popViewController(animated: true)
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
                    let cell = collectionView.dequeueCell(OrderTitleViewCell.self, for: indexPath)!
                    cell.textfield.addAction(UIAction(handler: { field in
                        self.isTitleEmpty = (field.sender as? UITextField)?.text?.isEmpty ?? false
                    }), for: .editingChanged)
                    return cell
                case .multiSelection:
                    switch item {
                    case let item as OrderMultiSelectionItem:
                        if !item.options.isEmpty {
                            let cell = collectionView.dequeueCell(OrderMultiSelectionCell.self, for: indexPath)
                            let numberOfItems = collectionView.numberOfItems(inSection: indexPath.section)
                            let shouldCornerBottom = (numberOfItems - 1 == indexPath.item) && !section.hasFooter
                            cell?.dot.backgroundColor = section.dotColor
                            cell?.apply(item, shouldCornerTop: indexPath.item == 0, shouldCornerBottom: shouldCornerBottom) { selectedItem in
                                self.selected += 1
                            }
                            cell?.selectionButton.actionButton.pressHandler { [weak self] _ in
                                if let actionSheet = cell?.actionSheet {
                                    self?.present(actionSheet, animated: true)
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
                                self?.present(actionSheet, animated: true)
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
                
                let isLastSection = sectionIndex == self.sections.count - 1
                let sectionInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: isLastSection ? 70 : 0, trailing: 20)
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

final class SubmissionRequestDataModel: Codable {
    var name: String?
    var dough: String?
    var thickness: String?
    var amount: String?
    var sauce: String?
    var cheese: String?
    
    var isDone: Bool {
        dough != nil && thickness != nil && amount != nil && sauce != nil && cheese != nil
    }
}
