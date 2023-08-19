//
//  RegisterViewController.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/20.
//

import Photos
import Combine
import UIKit
import SnapKit

final class RegisterViewController: UIViewController {
    private let imagePicker = UIImagePickerController()
    private let imageView = UIImageView()
    private let addButton = UIButton(type: .system)
    private let submitButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let textView = DescriptionTextView()
    
    struct ViewModel {
        var pizzaName: String
    }
    
    private var viewModel: ViewModel
    private var comment: String?
    
    private var bag = Set<AnyCancellable>()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupAttribute()
    }
    
    private func setupAttribute() {
        view.backgroundColor = Const.backgroundColor
        addButton.backgroundColor = .clear
        addButton.setImage(.ic_plus, for: .normal)
        addButton.tintColor = Const.plusColor
        imageView.layer.cornerRadius = 24.0
        addButton.layer.cornerRadius = 24.0
        addButton.layer.borderColor = Const.plusColor.cgColor
        addButton.layer.borderWidth = 1.4
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.setBackgroundColor(Const.submitButtonColor, for: .normal)
        submitButton.setBackgroundColor(Const.disabledSubmitButtonColor, for: .disabled)
        submitButton.isEnabled = false
        submitButton.setTitle("Sumbit", for: .normal)
        
        titleLabel.setText(viewModel.pizzaName, attributes: Const.titleAttributes)
        titleLabel.textAlignment = .center
        textView.placeholderText = "Describe your recipe in up to 100 characters"
        textView.backgroundColor = Const.textViewBackgroundColor
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        textView.commentPublisher
            .sink { [weak self] comment in
                guard let self else { return }
                self.comment = comment
                self.checkIsSubmitEnabled()
            }
            .store(in: &bag)
    }
    
    private func setupLayout() {
        let containerView = UIView()
        
        view.addSubview(containerView)
        view.addSubview(submitButton)
        containerView.addSubview(imageView)
        containerView.addSubview(addButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(textView)
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(addButton)
        }
        addButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(210)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview()
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(97)
            make.bottom.equalToSuperview()
        }
        
        submitButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(70)
        }
    }
    
    @objc private func didTapAddButton() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true // 사진 선택 후 편집 가능 여부
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private enum Const {
        static let plusColor = UIColor(red: 0.85, green: 0.84, blue: 0.82, alpha: 1)
        static let submitButtonColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
        static let submitTitleButtonColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
        static let disabledSubmitButtonColor = UIColor(red: 0.85, green: 0.84, blue: 0.84, alpha: 1)
        static let backgroundColor = UIColor(red: 0.99, green: 0.98, blue: 0.97, alpha: 1)
        static let textViewBackgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.93, alpha: 1)
        static let titleAttributes: NSMutableAttributedString.PHAttributes = .init(
            weight: .gellix(.bold),
            size: 24,
            textColor: UIColor(red: 0.19, green: 0.19, blue: 0.19, alpha: 1)
        )
    }
    
    private func checkIsSubmitEnabled() {
        let isEnabled = imageView.image != nil && comment != nil && comment?.isEmpty == false
        submitButton.isEnabled = isEnabled
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            print("### editedImage", editedImage)
            addButton.layer.borderWidth = 0
            addButton.setImage(nil, for: .normal)
            imageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            print("### originalImage", originalImage)
            addButton.layer.borderWidth = 0
            addButton.setImage(nil, for: .normal)
            addButton.setImage(originalImage, for: .normal)
        }
        
        checkIsSubmitEnabled()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
