//
//  DescriptionTextView.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/20.
//

import Combine
import UIKit
import SnapKit

final class DescriptionTextView: UITextView {
    private var placeholderLabel: UILabel?
    
    private let commentSubject = CurrentValueSubject<String, Never>("")
    
    var placeholderText: String? {
        get { placeholderLabel?.text }
        set { configurePlaceholderLabel(newValue) }
    }
    
    var commentPublisher: AnyPublisher<String, Never> {
        commentSubject.eraseToAnyPublisher()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleAfterSendComment() {
        self.text.removeAll()
        textViewDidChange(self)
    }
    
    private func updateText(_ text: String?) {
        defer { updatePlaceholder() }
        
        guard let text,
              text.isEmpty == false
        else { return }
        
        attributedText = NSMutableAttributedString.build(
            string: text,
            attributes: Const.defaulAttributes
        )
    }
    
    private func updatePlaceholder() {
        placeholderLabel?.isHidden = text.isEmpty == false
    }
}

extension DescriptionTextView {
    private func setupUI() {
        autocorrectionType = .no
        spellCheckingType = .no
        isScrollEnabled = false
        textContainer.lineFragmentPadding = .zero
        textContainerInset = Const.textInset
        tintColor = UIColor(red: 0.31, green: 0.31, blue: 0.29, alpha: 1)
        typingAttributes = Const.defaulAttributes.dictionary
        delegate = self
    }
    
    private func configurePlaceholderLabel(_ placeholder: String?) {
        let label: UILabel
        if let placeholderLabel {
            label = placeholderLabel
        } else {
            label = UILabel()
            label.numberOfLines = 0
            self.placeholderLabel = label
        }
        
        label.setText(placeholder, attributes: Const.placeholderAttributes)
        
        if label.superview == nil {
            addSubview(label)
        }
        
        label.snp.remakeConstraints { make in
            let topOffset = textContainerInset.top
            make.top.equalToSuperview().offset(topOffset)
            make.leading.equalToSuperview().offset(textContainerInset.left)
        }
        
        updatePlaceholder()
    }
}

extension DescriptionTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let selectedRange = textView.selectedRange
        updateText(textView.text)
        textView.selectedRange = selectedRange
        commentSubject.send(textView.text)
    }
}

extension DescriptionTextView {
    enum Const {
        static let maxLineCount: Int = 4
        static let minimumWarningCount: Int = 100
        static let maximumLimitCount: Int = 500
        static let minimumViewHeight: CGFloat = 22
        static let textInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let defaulAttributes = NSMutableAttributedString.PHAttributes(
            weight: .gellix(.medium),
            size: 16,
            textColor: UIColor(red: 0.31, green: 0.31, blue: 0.29, alpha: 1)
        )
        static let placeholderAttributes = NSMutableAttributedString.PHAttributes(
            weight: .gellix(.medium),
            size: 16,
            textColor: UIColor(red: 0.76, green: 0.76, blue: 0.74, alpha: 1)
        )
    }
}

extension NSMutableAttributedString.PHAttributes {
    var dictionary: [NSAttributedString.Key: Any] {
        NSMutableAttributedString
            .build(string: " ", attributes: self)
            .attributes(at: 0, effectiveRange: nil)
    }
}
