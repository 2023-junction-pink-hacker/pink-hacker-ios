//
//  FeedCell.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/20.
//

import Combine
import UIKit
import SnapKit
import Then
import Kingfisher

final class FeedCell: UICollectionViewCell {
    private let tagView = UIView()
    private let tagLabel = UILabel()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    
    struct ViewModel: Hashable {
        var id: Int
        var orderCount: Int
        var imageUrl: String?
        var title: String
        var content: String
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAttribute()
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        titleLabel.text = nil
        contentLabel.text = nil
        tagLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: ViewModel) {
        tagLabel.setText("\(viewModel.orderCount) orders", attributes: Const.tagAttributes)
        titleLabel.setText(viewModel.title, attributes: Const.titleAttributes)
        contentLabel.setText(viewModel.content, attributes: Const.contentAttributes)
        imageView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.93, alpha: 1)
        if let urlString = viewModel.imageUrl, let url = URL(string: urlString)  {
            imageView.kf.setImage(with: url, options: [.transition(.fade(0.1))])
        }
        imageView.layer.masksToBounds = true
        contentLabel.numberOfLines = 3
    }
}

extension FeedCell {
    private func setupAttribute() {
        tagView.backgroundColor = Const.tagBackgroundColor
        imageView.contentMode = .scaleAspectFill
    }
    
    private func setupLayout() {
        contentView.addSubview(imageView)
        imageView.addSubview(tagView)
        tagView.addSubview(tagLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        
        imageView.snp.makeConstraints { make in
            let height = screenWidth - 50
            make.height.equalTo(height)
            make.leading.trailing.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tagLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        tagView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
    }
}

extension FeedCell {
    static func height(_ item: ViewModel) -> CGFloat {
        let availableWidth = screenWidth - 50
        let titleHeight = Self.heightWithLabel(
            string: item.title,
            attributes: Const.titleAttributes,
            availableWidth: availableWidth,
            maxLines: 1
        )
        let contentHeight = Self.heightWithLabel(
            string: item.content,
            attributes: Const.contentAttributes,
            availableWidth: availableWidth,
            maxLines: 3
        )
        return availableWidth
        + 20
        + titleHeight
        + 10
        + contentHeight
        
    }
    
    private static func heightWithLabel(
        string: String,
        attributes: NSMutableAttributedString.PHAttributes,
        availableWidth: CGFloat,
        maxLines: Int?
    ) -> CGFloat {
        let label = UILabel()
        label.numberOfLines = maxLines ?? 0
        label.attributedText = NSMutableAttributedString.build(
            string: string,
            attributes: attributes
        )
        
        let height = label
            .sizeThatFits(
                CGSize(
                    width: availableWidth,
                    height: .greatestFiniteMagnitude
                )
            )
            .height
        
        return height
    }
}

private extension FeedCell {
    enum Const {
        static let titleAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.bold),
            size: 24,
            textColor: Const.titleColor
        )
        static let contentAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.medium),
            size: 16,
            textColor: Const.contentColor
        )
        static let tagAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.semibold),
            size: 16,
            textColor: .white
        )
        static let tagBackgroundColor = UIColor(red: 0.19, green: 0.19, blue: 0.19, alpha: 1)
        static let titleColor = UIColor(red: 0.19, green: 0.19, blue: 0.19, alpha: 1)
        static let contentColor = UIColor(red: 0.31, green: 0.31, blue: 0.29, alpha: 1)
    }
}
