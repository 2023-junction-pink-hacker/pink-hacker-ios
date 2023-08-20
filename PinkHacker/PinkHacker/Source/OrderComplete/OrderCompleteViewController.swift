//
//  OrderCompleteViewController.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/19.
//

import UIKit
import Then
import SnapKit

final class OrderCompleteViewController: UIViewController {
    private let titleLabel = UILabel()
    private let pizzaImageView = UIImageView()
    private let viewOrderButton = UIButton()
    private let clockIconImageView = UIImageView().then {
        $0.image = .ic_clock
    }
    private let timeLabel = UILabel()
    private let timeUnitLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private var viewModel: ViewModel?
    
    struct ViewModel {
        var pizzaName: String
        var endTime: String
    }
    
    init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttribute()
        setupLayout()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePizza()
    }
    
    @objc private func didTapViewOrderButton() {
        NotificationCenter.default.post(name: .didTapViewOrder, object: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func animatePizza() {
        self.view.layoutIfNeeded()
        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            options: [.autoreverse, .repeat],
            animations: {
                self.pizzaImageView.frame.origin.y -= 30
            },
            completion: nil
        )
    }
    
    func configure() {
        titleLabel.attributedText = NSMutableAttributedString()
            .appending(string:  "Your custom-made\n", attributes: Const.titleAttributes)
            .appending(string: "\(viewModel?.pizzaName ?? "???")", attributes: Const.highlightedAttributes)
            .appending(string: "\norder has been placed", attributes: Const.titleAttributes)
        titleLabel.textAlignment = .center
        timeLabel.setText("\(viewModel?.time.0 ?? "??:??")", attributes: Const.timeAttributes)
        let timeUnit = viewModel?.time.1?.lowercased() ?? "am"
        timeUnitLabel.setText(timeUnit, attributes: Const.timeUnitAttributes)
    }
}

extension OrderCompleteViewController {
    private func setupAttribute() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = Const.backgroundColor
        titleLabel.numberOfLines = 0
        let title = NSMutableAttributedString.build(string: "View Order", attributes: Const.buttonTitleAttributes)
        viewOrderButton.setAttributedTitle(title, for: .normal)
        viewOrderButton.setBackgroundColor(Const.disabledButtonColor, for: .disabled)
        viewOrderButton.setBackgroundColor(Const.enabledButtonColor, for: .normal)
        viewOrderButton.layer.cornerRadius = 16
        viewOrderButton.layer.masksToBounds = true
        viewOrderButton.addTarget(self, action: #selector(didTapViewOrderButton), for: .touchUpInside)
        pizzaImageView.contentMode = .scaleAspectFit
        pizzaImageView.image = .img_pizza
        descriptionLabel.setText("Estimated cook time", attributes: Const.descriptionAttributes)
    }
    
    private func setupLayout() {
        let timeView = setupTimeView()
        
        view.addSubview(titleLabel)
        view.addSubview(pizzaImageView)
        view.addSubview(viewOrderButton)
        view.addSubview(timeView)
        view.addSubview(viewOrderButton)
        view.addSubview(descriptionLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(66)
            make.centerX.equalToSuperview()
        }
        pizzaImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.directionalHorizontalEdges.equalToSuperview().inset(60)
            make.centerX.equalToSuperview()
        }
        timeView.snp.makeConstraints { make in
            make.top.equalTo(pizzaImageView.snp.bottom).offset(54)
            make.centerX.equalToSuperview()
        }
        viewOrderButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(48)
            make.directionalHorizontalEdges.equalToSuperview().inset(21)
            make.height.equalTo(57)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(timeView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupTimeView() -> UIView {
        let containerView = UIView()
        
        containerView.addSubview(timeUnitLabel)
        containerView.addSubview(clockIconImageView)
        containerView.addSubview(timeLabel)
        
        timeLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        clockIconImageView.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.leading.equalToSuperview()
            make.trailing.equalTo(timeLabel.snp.leading).offset(-12)
            make.top.equalTo(timeLabel).offset(4)
        }
        timeUnitLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeLabel.snp.trailing).offset(-12)
            make.bottom.equalTo(timeLabel)
            make.trailing.equalToSuperview()
        }
        
        return containerView
    }
}

extension OrderCompleteViewController.ViewModel {
    var time: (String?, String?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let date = dateFormatter.date(from: self.endTime) {
            dateFormatter.locale = .init(identifier: "en")
            dateFormatter.dateFormat = "h:mm "
            let time = dateFormatter.string(from: date)
            dateFormatter.dateFormat = "a"
            let unit = dateFormatter.string(from: date)
            return (time, unit)
        }
        
        return (nil, nil)
    }
}

private extension OrderCompleteViewController {
    enum Const {
        static let titleAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.bold),
            size: 24,
            textColor: Const.titleColor
        )
        static let highlightedAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.bold),
            size: 24,
            textColor: Const.highlightedColor
        )
        static let buttonTitleAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.semibold),
            size: 19,
            textColor: .white
        )
        static let timeAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.bold),
            size: 60,
            textColor: Const.timeColor
        )
        static let timeUnitAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.bold),
            size: 40,
            textColor: Const.timeColor
        )
        static let descriptionAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.semibold),
            size: 18,
            textColor: Const.descriptionColor
        )
        static let titleColor = UIColor(red: 0.19, green: 0.19, blue: 0.19, alpha: 1)
        static let highlightedColor = UIColor(red: 1, green: 0.52, blue: 0.37, alpha: 1)
        static let disabledButtonColor = UIColor(red: 0.85, green: 0.84, blue: 0.84, alpha: 1)
        static let enabledButtonColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
        static let timeColor = UIColor(red: 0.19, green: 0.19, blue: 0.19, alpha: 1)
        static let backgroundColor = UIColor(red: 0.99, green: 0.98, blue: 0.97, alpha: 1)
        static let descriptionColor = UIColor(red: 0.76, green: 0.76, blue: 0.74, alpha: 1)
    }
}
