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
    var cancalleble: AnyCancellable?
    
    private let naviBar = PHNaviBar(frame: .zero)
    private let imageView = UIImageView()
    private let addButton = UIButton(type: .system)
    private let submitButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let textView = DescriptionTextView()
    private let summaryView = RecipeSummaryView()
    
    struct ViewModel {
        var recipeId: Int
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        view.endEditing(true)
    }
    
    private func setupAttribute() {
        view.backgroundColor = Const.backgroundColor
        naviBar.title = "Add your recipe"
        naviBar.leftBarItem = .back
        naviBar.leftButton.addTarget(self, action: #selector(didTapLeftButton), for: .touchUpInside)
        addButton.backgroundColor = .clear
        addButton.setImage(.ic_plus, for: .normal)
        addButton.tintColor = Const.plusColor
        imageView.layer.cornerRadius = 24.0
        addButton.layer.cornerRadius = 24.0
        addButton.layer.borderColor = Const.plusColor.cgColor
        addButton.layer.borderWidth = 1.4
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.setBackgroundColor(Const.submitButtonColor, for: .normal)
        submitButton.setBackgroundColor(Const.disabledSubmitButtonColor, for: .disabled)
        let attrbiutedTitle = NSMutableAttributedString.build(string: "Submit", attributes: .init(weight: .gellix(.semibold), size: 19, textColor: .white))
        submitButton.setAttributedTitle(attrbiutedTitle, for: .normal)
        submitButton.isEnabled = false
        submitButton.titleEdgeInsets = .init(top: -18, left: 0, bottom: 18, right: 0)
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
        
        view.addSubview(naviBar)
        view.addSubview(containerView)
        view.addSubview(submitButton)
        containerView.addSubview(imageView)
        containerView.addSubview(addButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(textView)
        containerView.addSubview(summaryView)
        
        naviBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        containerView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
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
        }
        
        summaryView.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
        submitButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(91)
        }
        
        summaryView.apply()
    }
    
    @objc private func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapAddButton() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true // 사진 선택 후 편집 가능 여부
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func didTapSubmitButton() {
        guard let comment else { return }
        
        cancalleble = RegisterRequest()
            .putPublisher(RegisterRequestDatat(recipeId: 5, description: comment))
            .sink { _ in } receiveValue: { [weak self] _ in
                NotificationCenter.default.post(name: .registerRecipe, object: nil)
                self?.navigationController?.popViewController(animated: true)
            }

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

final class RecipeSummaryView: UIView {
    
    var stackView: UIStackView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.93, alpha: 1)
        layer.cornerRadius = 10.0
        
        let stackView = UIStackView()
        stackView.spacing = 2.0
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20.0)
        }
        self.stackView = stackView
    }
    
    func apply() {
        let res = [["Dough", "Weat, Regular"], ["Sauce", "BBQ"], ["Cheese", "Cheddar"], ["Toppings", "Mushroom, Galic, Black Olives"]]
        
        let colors: [UIColor] = [UIColor(red: 0.89, green: 0.82, blue: 0.63, alpha: 1),
                                 UIColor(red: 1, green: 0.52, blue: 0.37, alpha: 1),
                                 UIColor(red: 1, green: 0.85, blue: 0.47, alpha: 1),
                                 UIColor(red: 0.47, green: 0.77, blue: 0.5, alpha: 1)]
        res.enumerated().forEach { (i, item) in
            let v = appendItem(title: item.first!, description: item[1])
            v.dot.backgroundColor = colors[i%colors.count]
        }
    }
    
    func appendItem(title: String, description: String) -> RecipeSummaryItemView {
        let itemView = RecipeSummaryItemView()
        itemView.titleLabel.text = title
        itemView.subtitleLabel.text = description
        stackView.addArrangedSubview(itemView)
        return itemView
    }
}


final class RecipeSummaryItemView: UIView {
    var dot: ColoredDot!
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        let stackView = UIStackView()
        stackView.alignment = .center
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0))
        }
        stackView.spacing = 8
        
        let dot = ColoredDot(color: .red)
        dot.snp.makeConstraints {
            $0.size.equalTo(12)
        }
        stackView.addArrangedSubview(dot)
        self.dot = dot
        
        let titleLabel = UILabel(weight: .semibold, size: 16, color: .label0)
        stackView.addArrangedSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let subtitleLabel = UILabel(weight: .medium, size: 16, color: UIColor(red: 0.69, green: 0.69, blue: 0.68, alpha: 1))
        stackView.addArrangedSubview(subtitleLabel)
        self.subtitleLabel = subtitleLabel
        
        let v = UIView()
        stackView.addArrangedSubview(v)
    }
}
