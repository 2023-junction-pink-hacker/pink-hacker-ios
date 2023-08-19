//
//  NicknameViewController.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/19.
//

import UIKit
import SnapKit
import Then

final class NicknameViewController: UIViewController {
    private let nicknameTitleLabel = UILabel()
    private let nicknameTextField = UITextField()
    private let dividerLineView = UIView()
    private let completeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttribute()
        setupLayout()
    }
    
    @objc private func didTapCompleteButton() {
        guard let window = UIApplication.shared.keyWindow else { return }
        let mainTabBarController = MainTabBarController()
        UIView.transition(
            with: window,
            duration: 0.2,
            options: .transitionCrossDissolve,
            animations: { window.rootViewController = mainTabBarController },
            completion: nil
        )
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let customAttributes: [NSAttributedString.Key : Any] = [.paragraphStyle: paragraph]
        textField.setText(
            textField.text,
            attributes: Const.nicknameAttributes,
            customAttributes: customAttributes
        )
        
        completeButton.isEnabled = textField.text?.isEmpty == false
    }
}

extension NicknameViewController {
    private func setupAttribute() {
        view.backgroundColor = .white
        nicknameTitleLabel.setText("Enter your name", attributes: Const.nicknameTitleAttributes)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let customAttributes: [NSAttributedString.Key : Any] = [.paragraphStyle: paragraph]
        nicknameTextField.attributedPlaceholder = NSMutableAttributedString.build(
            string: "Name",
            attributes: Const.placeholderAttributes,
            customAttributes: customAttributes
        )
        nicknameTextField.font = .gellizFont(weight: .bold, size: 48)
        nicknameTextField.autocorrectionType = .no
        nicknameTextField.borderStyle = .none
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        dividerLineView.backgroundColor = Const.dividerColor
        let title = NSMutableAttributedString.build(string: "Confirm", attributes: Const.buttonTitleAttributes)
        completeButton.setAttributedTitle(title, for: .normal)
        completeButton.setBackgroundColor(Const.disabledButtonColor, for: .disabled)
        completeButton.setBackgroundColor(Const.enabledButtonColor, for: .normal)
        completeButton.layer.cornerRadius = 16
        completeButton.layer.masksToBounds = true
        completeButton.isEnabled = false
        completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(nicknameTitleLabel)
        view.addSubview(nicknameTextField)
        view.addSubview(dividerLineView)
        view.addSubview(completeButton)
        
        nicknameTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            make.centerX.equalToSuperview()
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameTitleLabel.snp.bottom).offset(126)
            make.centerX.equalToSuperview()
            make.height.equalTo(72)
            make.leading.trailing.equalToSuperview().inset(42)
        }
        dividerLineView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom)
            make.leading.trailing.equalTo(nicknameTextField)
            make.height.equalTo(2)
        }
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(21)
            make.top.equalTo(dividerLineView.snp.top).offset(42)
            make.height.equalTo(57)
        }
    }
}

private extension NicknameViewController {
    enum Const {
        static let nicknameTitleAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.bold),
            size: 20,
            textColor: Const.titleColor
        )
        static let placeholderAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.bold),
            size: 48,
            textColor: Const.placeholderColor
        )
        static let nicknameAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.bold),
            size: 48,
            textColor: Const.nicknameColor
        )
        static let buttonTitleAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.semibold),
            size: 19,
            textColor: .white
        )
        static let titleColor = UIColor(red: 0.192, green: 0.187, blue: 0.187, alpha: 1)
        static let placeholderColor = UIColor(red: 0.9, green: 0.88, blue: 0.88, alpha: 1)
        static let nicknameColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
        static let dividerColor = UIColor(red: 0.79, green: 0.78, blue: 0.78, alpha: 1)
        static let disabledButtonColor = UIColor(red: 0.85, green: 0.84, blue: 0.84, alpha: 1)
        static let enabledButtonColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
    }
}
