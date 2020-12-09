//
//  OneTimeCodeTextField.swift
//  One Time Code
//
//  Created by Peter Bassem on 12/8/20.
//

import UIKit

protocol OneTimeCodeTextFieldDelegate: class {
    
    func didCompleteOTPText(otpText text: String)
    func isValidCode(isValid valid: Bool)
}

@IBDesignable
class OneTimeCodeTextField: UITextField {
    
    // MARK: - IBInspectable
    @IBInspectable var digitsCount: Int = 6 {
        didSet { configure(with: digitsCount) }
    }
    @IBInspectable var spacing: CGFloat = 8 {
        didSet { configure(with: digitsCount) }
    }
    @IBInspectable var textBackgroundColor: UIColor? {
        didSet { updateView() }
    }
    @IBInspectable var digitTextColor: UIColor? {
        didSet { updateView() }
    }
    @IBInspectable var defaultCharacter: String = "" {
        didSet { updateView() }
    }
    var digitFont: UIFont? {
        didSet { updateView() }
    }
    @IBInspectable var digitLabelCornerRadius: CGFloat = 0.0 {
        didSet { updateView() }
    }
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet { updateView() }
    }
    @IBInspectable var borderColor: UIColor = .clear {
        didSet { updateView() }
    }
    @IBInspectable internal var shadowColor: UIColor = .clear {
        didSet { updateView() }
    }
    @IBInspectable var shadowOpacity: Float = 0.0 {
        didSet { updateView() }
    }
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet { updateView() }
    }
    @IBInspectable var shadowOffsetX: CGFloat = 0.0 {
        didSet { updateView() }
    }
    @IBInspectable var shadowOffsetY: CGFloat = 0.0 {
        didSet { updateView() }
    }
    
    // MARK: - Closures (maybe change to delegates sooner..)
    var didEnterLastDigit: ((String) -> Void)?
    
    weak var otpDelegate: OneTimeCodeTextFieldDelegate?
    
    // MARK: - Private Variables
    private var isConfigured: Bool = false
    private lazy var stackView = UIStackView()
    private var digitLabels = [UILabel]()
    private lazy var tapRecognizer: UITapGestureRecognizer = {
       let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure(with: digitsCount)
    }
    
    // MARK: - Helpers
    func configure(with slotCount: Int) {
        guard isConfigured == false else { return }
        isConfigured.toggle()
        
        configureTextField()
        
        let labelsStackView = createLabelsStackView(with: slotCount)
        addSubview(labelsStackView)
        
        addGestureRecognizer(tapRecognizer)
        
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: topAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .asciiCapableNumberPad
        textContentType = .oneTimeCode
        borderStyle = .none
        becomeFirstResponder()
        
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
        
        semanticContentAttribute = .unspecified

    }
    
    private func createLabelsStackView(with count: Int) -> UIStackView {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        for _ in 1 ... count {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            label.text = defaultCharacter
            label.clipsToBounds = true
            label.layer.masksToBounds = false
            
            stackView.addArrangedSubview(label)
            
            digitLabels.append(label)
        }
        setNeedsDisplay()
        return stackView
    }
    
    // MARK: - Selectors
    @objc
    private func textDidChange() {
        
        guard let text = text, text.count <= digitLabels.count else { return }
        print(text)
        
        for i in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[i]
            
            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text = String(text[index])
            } else {
                if defaultCharacter != "" {
                    currentLabel.text = defaultCharacter
                } else {
                    currentLabel.text?.removeAll()
                }
            }
        }
        
        if text.count == digitLabels.count {
            otpDelegate?.didCompleteOTPText(otpText: text)
            otpDelegate?.isValidCode(isValid: true)
        } else {
            otpDelegate?.isValidCode(isValid: false)
        }
    }
    
    private func updateView() {
        guard digitLabels.count > 0 else { return }
        stackView.spacing = spacing
        if let textBackgroundColor = textBackgroundColor {
            digitLabels.forEach { $0.backgroundColor = textBackgroundColor }
            setNeedsDisplay()
        }
        if let digitTextColor = digitTextColor {
            digitLabels.forEach { $0.textColor = digitTextColor }
            setNeedsDisplay()
        }
        if let digitFont = digitFont {
            digitLabels.forEach { $0.font = digitFont }
        }
        if defaultCharacter != "" {
            digitLabels.forEach { $0.text = defaultCharacter }
        }
        
        digitLabels.forEach { $0.layer.cornerRadius = digitLabelCornerRadius }
        digitLabels.forEach { $0.layer.borderWidth = borderWidth }
        digitLabels.forEach { $0.layer.borderColor = borderColor.cgColor }
        digitLabels.forEach { $0.layer.shadowColor = shadowColor.cgColor }
        digitLabels.forEach { $0.layer.shadowOpacity = shadowOpacity }
        digitLabels.forEach { $0.layer.shadowRadius = shadowRadius }
        digitLabels.forEach { $0.layer.shadowOffset = .init(width: shadowOffsetX, height: shadowOffsetY) }
    }
}

// MARK: - UITextFieldDelegate
extension OneTimeCodeTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else { return false }
        return characterCount < digitLabels.count || string == ""
    }
}
