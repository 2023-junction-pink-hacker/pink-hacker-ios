//
//  MyOrderHeaderView.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/20.
//

import Combine
import UIKit
import SnapKit
import Then

enum MyOrderProgress {
    case received
    case cooking
    case finished
}

final class MyOrderHeaderView: UIView {
    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let nameLabel = UILabel()
    private let leftTimeLabel = UILabel()
    private let progressBar = UIView()
    private let receivedLabel = UILabel()
    private let cookingLabel = UILabel()
    private let finishLabel = UILabel()
    
    private var bag = Set<AnyCancellable>()
    
    private var viewModel: ViewModel?
    
    struct ViewModel {
        var name: String
        var progress: MyOrderProgress
        var endTime: String
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAttribute()
        setupLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: ViewModel) {
        self.viewModel = viewModel
        imageView.image = viewModel.progress.image
        nameLabel.setText(viewModel.name, attributes: Const.pizzaNameAttributes)
        receivedLabel.setText("Received", attributes: Const.foodStageAttributes)
        cookingLabel.setText("Cooking", attributes: Const.foodStageAttributes)
        finishLabel.setText("Finish", attributes: Const.foodStageAttributes)
        
        switch viewModel.progress {
        case .finished: break
        case .cooking:
            finishLabel.setText("Finish", attributes: Const.foodNotStageAttributes)
        case .received:
            cookingLabel.setText("Cooking", attributes: Const.foodNotStageAttributes)
            finishLabel.setText("Finish", attributes: Const.foodNotStageAttributes)
        }
        
        updateLeftTimeLabel()
    }
    
    private func updateLeftTimeLabel() {
        if let leftTime = viewModel?.leftTime {
            leftTimeLabel.setText(leftTime, attributes: Const.timeAttributes)
        } else {
            leftTimeLabel.setText("It’s ready!", attributes: Const.timeAttributes)
        }
    }
}

extension MyOrderHeaderView {
    private func setupAttribute() {
        descriptionLabel.setText("My menu", attributes: Const.descriptionAttributes)
        progressBar.backgroundColor = .black
    }
    
    private func setupLayout() {
        addSubview(imageView)
        addSubview(descriptionLabel)
        addSubview(nameLabel)
        addSubview(leftTimeLabel)
        addSubview(progressBar)
        
        UIStackView().do {
            $0.alignment = .firstBaseline
            $0.distribution = .equalSpacing
            $0.axis = .horizontal
            
            $0.addArrangedSubview(receivedLabel)
            $0.addArrangedSubview(cookingLabel)
            $0.addArrangedSubview(finishLabel)
            
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(progressBar.snp.bottom).offset(10)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }
        
        imageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.size.equalTo(102)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView)
            make.leading.equalTo(imageView.snp.trailing).offset(16)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(descriptionLabel)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(4)
        }
        leftTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(descriptionLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
        }
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(27)
            make.height.equalTo(12)
            make.horizontalEdges.equalToSuperview()
        }
        progressBar.layer.cornerRadius = 6
        progressBar.layer.masksToBounds = true
    }
    
    private func bind() {
        Timer
            .publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                guard let window, window.frame.intersects(self.convert(self.bounds, to: window))
                else { return }
                self.updateLeftTimeLabel()
            }
            .store(in: &bag)
    }
}

extension MyOrderProgress {
    var image: UIImage? {
        switch self {
        case .received: return .ic_progress_1
        case .cooking: return .ic_progress_2
        case .finished: return .ic_progress_3
        }
    }
}

extension MyOrderHeaderView.ViewModel {
    var leftTime: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        guard let endTime = dateFormatter.date(from: self.endTime) else { return nil }

        guard Date.now <= endTime else { return nil }
        
        let leftDuration = DateInterval(start: Date.now, end: endTime).duration
        let dayInterval: TimeInterval = 86400 // 60 x 60 x 1000
        
        if (leftDuration / dayInterval) >= 1 {
            let components = Calendar.current.dateComponents([.day], from: Date.now, to: endTime)
            return "\(components.day ?? 0)일"
        }
        
        let total: Int = Int(leftDuration)
        let hour = (total / 3600) - 9 // GMT 9시간을 빼줍니다.
        let minute = (hour + total % 3600) / 60
        
        return String(format: "%02dm", minute)
    }
}

private extension MyOrderHeaderView {
    enum Const {
        static let timeAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.semibold),
            size: 18,
            textColor: Const.timeColor
        )
        static let descriptionAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.semibold),
            size: 13,
            textColor: Const.descriptionColor
        )
        static let pizzaNameAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.bold),
            size: 24,
            textColor: Const.blackColor
        )
        static let foodStageAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.bold),
            size: 14,
            textColor: Const.blackColor
        )
        static let foodNotStageAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.bold),
            size: 14,
            textColor: Const.grayColor
        )
        static let descriptionColor = UIColor(red: 0.76, green: 0.76, blue: 0.74, alpha: 1)
        static let blackColor = UIColor(red: 0.19, green: 0.19, blue: 0.19, alpha: 1)
        static let timeColor = UIColor(red: 1, green: 0.52, blue: 0.37, alpha: 1)
        static let grayColor = UIColor(red: 0.85, green: 0.84, blue: 0.81, alpha: 1)
        static let progressbarColor = UIColor(red: 0.96, green: 0.96, blue: 0.93, alpha: 1)
    }
}
