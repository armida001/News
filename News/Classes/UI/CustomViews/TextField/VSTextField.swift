//
//  VSTextField.swift
//  mobile bank
//
//  Created by Stanislav Kaluzhnyi on 06/04/2017.
//  Copyright © 2017 Infosysco. All rights reserved.
//

import UIKit

enum ControlState {
    case passive
    case focused
    case invalid
    case valid
    case locked
}

protocol StatableControl {
    
    var controlState: ControlState { get set }
    func didChangeControlState(to: ControlState)
}

enum TextFieldFormatting {
    case phoneNumber
    case phoneNumberWithoutCode
    case phoneNumberWithCode
    case email
    case firstName
    case code
    case username
    case name
    case password
    case custom
    case noFormatting
    case fullName
    case period
    case integer
    case double
    case cardNumber
    case cardDate
    case cvv
    case cardHolder
    case cardHolderAllLetters
}

enum ColorableStyle: Int {
    case passive = 0
    case focused
    case valid
    case invalid
    case locked
}

protocol Colorable {
    var colors: [UIColor] { get set }
}

extension Colorable {
    
    func colorFor(style: ColorableStyle) -> UIColor {
        // ARRAY COUNT MUST MATCH THE QUANTITY OF CASES OF ENUM
        return colors[style.rawValue]
    }
}

class VSTextField: UITextField, Colorable {
    
    // MARK: Public fields
    
    var defaultColor: UIColor = .black
    var colors: [UIColor] = [ .black,
                              .black,
                              .black,
                              UIColor.color_33_40_50,
                              UIColor.color_77_170_179]
    
    var textMask: TextFieldMask = TextFieldMasks.noMask
    var validator: TextValidator = TextValidators.any
    
    var shouldPaste: Bool = true
    var isValid: Bool = false
    var finalizerValidation: ((Bool?) -> ())?
    var finalizerStateChanging: (() -> ())?
    var finalizerTextDidChange: (() -> ())?
    var actionBeginEditing: (() -> Void)?
    var actionChangeText: (() -> Void)?
    
    var externalValidation: (()->(Bool)) = { true }
    @IBOutlet weak var previousField: UITextField?
    @IBOutlet weak var nextField: UITextField?
    
    let bottomLineView: UIView = UIView(frame: .zero)
    
    fileprivate var textBackup: String = ""
    
    @IBInspectable var bottomLineColor: UIColor = UIColor.color_33_40_50
    @IBInspectable var bottomLineBottomSpacing: CGFloat = 5.0
    
    var shouldChangeToInvalidControlState: Bool = true
    var controlState: ControlState = .passive {
        didSet {
            didChangeControlState(to: controlState)
        }
    }
    
    // MARK: Private fields
    
    fileprivate var formatting: TextFieldFormatting = .noFormatting {
        didSet {
            autocapitalizationType = .none
            autocorrectionType = .no
            keyboardType = .default
            switch formatting {                            
            case .code:
                keyboardType = .numberPad
                textMask = TextFieldMasks.code
                validator = TextValidators.code
            case .custom:
                textMask = TextFieldMasks.noMask
                validator = TextValidators.any
            case .email:
                keyboardType = .emailAddress
                textMask = TextFieldMasks.asciiLettersOnly
                validator = TextValidators.email
            case .firstName, .fullName:
                textMask = TextFieldMasks.noMask
                validator = TextValidators.firstName
                autocapitalizationType = .words
            case .noFormatting:
                textMask = TextFieldMasks.noMask
                validator = TextValidators.any
                autocapitalizationType = .words
            case .username:
                textMask = TextFieldMasks.noMask
                validator = TextValidators.username
            case .name:
                textMask = TextFieldMasks.noMask
                validator = TextValidators.name
            case .password:
                textMask = TextFieldMasks.noMask
                validator = TextValidators.password
            case .phoneNumberWithoutCode:
                textMask = TextFieldMasks.phoneNumberWithoutCode
                validator = TextValidators.phoneNumberWithoutCode
                keyboardType = .numberPad
            case .phoneNumber:
                textMask = TextFieldMasks.phoneNumber
                validator = TextValidators.phoneNumber
                keyboardType = .numberPad
            case .phoneNumberWithCode:
                textMask = TextFieldMasks.phoneNumber
                validator = TextValidators.phoneNumber                
                keyboardType = .numberPad
            case .period:
                textMask = TextFieldMasks.period
                validator = TextValidators.period
                keyboardType = .numberPad
            case .integer:
                textMask = TextFieldMasks.noMask
                validator = TextValidators.integer
                keyboardType = .decimalPad
            case .double:
                textMask = TextFieldMasks.noMask
                validator = TextValidators.double
                keyboardType = .decimalPad
            case .cardNumber:
                textMask = TextFieldMasks.cardNumber
                validator = TextValidators.cardNumber
                keyboardType = .numberPad
            case .cardDate:
                textMask = TextFieldMasks.cardDate
                validator = TextValidators.cardDate
                keyboardType = .numberPad
            case .cvv:
                textMask = TextFieldMasks.cvv
                validator = TextValidators.cvv
                keyboardType = .numberPad
            case .cardHolder:
                textMask = TextFieldMasks.asciiLettersOnly
                validator = TextValidators.cardHolder
                autocapitalizationType = .allCharacters
            case .cardHolderAllLetters:
                textMask = TextFieldMasks.noMask
                validator = TextValidators.cardHolderAllLetters
                autocapitalizationType = .allCharacters
            }
        }
    }
    
    // всегда возвращает текст без форматирования
    override var text: String? {
        set {
            changeText(to: newValue ?? "")
        }
        get {
            return textMask.unformat(text: super.text ?? "")
        }
    }
    
    @IBInspectable
    public var placeholderColor : UIColor {
        get {
            return UIColor.black
        }
        set(color) {
            setAttrPlaceholderColor(color)
        }
    }
    
    private func initPlaceholder() -> NSMutableAttributedString {
        attributedPlaceholder = NSAttributedString.toMutable(attributedPlaceholder)
        return (attributedPlaceholder as? NSMutableAttributedString) ?? NSMutableAttributedString(string:" ")
    }
    
    private func setAttrPlaceholderColor(_ color : UIColor) {
        let placeholder = initPlaceholder()
        placeholder.addAttributes([NSAttributedString.Key.foregroundColor:color], range:NSMakeRange(0, placeholder.length))
        
        // Don't remove!!!
        // Workaround as color change is ignored in the another case
        let f = font
        font = nil
        font = f
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) {
            return shouldPaste
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //setBottomLine(withRect: bounds)
    }
    
    // MARK: Initialize
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        clipsToBounds = false
        registerForNotifications()
        setDefaultColor(color: super.textColor ?? .black)
        didChangeControlState(to: controlState)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
        registerForNotifications()
        setDefaultColor(color: super.textColor ?? .black)
        didChangeControlState(to: controlState)
    }
    
    // MARK: Deinitialize
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setDefaultColor(color: UIColor) {
        colors[0] = color
        colors[1] = color
        colors[2] = color
    }
    
    fileprivate func changeFieldStateColor(style: ColorableStyle) {
        let color = colorFor(style: style)
        textColor = color
    }
    
    fileprivate func changePlaceholderColor(style: ColorableStyle) {
        let color = colorFor(style: style)
        placeholderColor = color
    }

}

// MARK: Validation
extension VSTextField {
    fileprivate func validate() {
        guard let text = super.text else { return }
        self.isValid = validator.isValide(text: text.trimmingCharacters(in: .whitespaces))
        && externalValidation()
    }
    
    fileprivate func checkIsValid() {
        validate()
        if let finalizerValidation = finalizerValidation {
            finalizerValidation(isValid)
        }
    }
    
    func finalizeTextEntering() {
        removeTrailingSpacesIfExists()
    }
    
    private func removeTrailingSpacesIfExists() {
        guard let text = super.text else { return }
        super.text = text.trimmingCharacters(in: .whitespaces)
    }
    
}

// MARK: Formatting
extension VSTextField {
    func setFormattingType(formatting : TextFieldFormatting) {
        self.formatting = formatting
    }
}

// MARK: Extension for notifications (UITextFieldTextDidBeginEditing, UITextFieldTextDidChange, UITextFieldTextDidEndEditing).
extension VSTextField {
    fileprivate func registerForNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditing), name: UITextField.textDidEndEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidBeginEditing), name: UITextField.textDidBeginEditingNotification, object: self)
    }
    
    @objc func textDidEndEditing() {
//        finalizeTextEntering()
        checkIsValid()
        
        if isValid {
               controlState = .valid
        } else {
            controlState = .invalid
        }
        
        if let text = super.text {
            if formatting == .phoneNumber, text == "+" {
                self.text = ""
            }
            if formatting == .phoneNumberWithCode && (text == "+7 (" || text == "+7") {
                super.text = ""
            }
        }
    }
    
    @objc func textDidBeginEditing() {
        controlState = .focused
        if let text = text, text.isEmpty {
            if formatting == .phoneNumber {
                self.text = "+"
            } else if formatting == .phoneNumberWithCode {
                super.text = "+7 ("
            }
        }
    }
    
    @objc func textDidChange() {
        changeText(to: super.text!)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //setBottomLine(withRect: rect)
    }
}

extension VSTextField {
    
    fileprivate func changeText(to string: String) {
        
        let formatted = textMask.format(text: textMask.unformat(text: string), from: nil)
        var range: UITextRange?
        let text = formatted
    
        if string.isEmpty, let start = position(from: beginningOfDocument, offset: formatted.count) {
            range = textRange(from: start, to: start)
        } else 
        if let currentRange = selectedTextRange,
            let calculatedRange = calculateRange(unformatted: string,
                                                 formatted: formatted,
                                                 currentRange: currentRange) {
            range = calculatedRange
        }
        
        super.text = text
        textBackup = text
        // normal cursor behavior for nil
        if let range = range {
            selectedTextRange = range
        }
        finalizerTextDidChange?()
        checkIsValid()
    }
    
    private func calculateRange(unformatted: String, formatted: String, currentRange: UITextRange) -> UITextRange? {
        let currentCursorPosition = offset(from: beginningOfDocument, to: currentRange.start)
        guard unformatted.count > currentCursorPosition else {
            return nil
        }
        let unformattedAfterCursorString = unformatted.suffix(currentCursorPosition)
        var formattedAfterCursorString = unformattedAfterCursorString
        
        let isCursorInFormattedStringRange = formatted.count > currentCursorPosition
        if isCursorInFormattedStringRange {
            formattedAfterCursorString = formatted.suffix(currentCursorPosition)
        }
        let formattedLengthDelta = formattedAfterCursorString.count - unformattedAfterCursorString.count
        
        let isPatternCharactedDeleted = formatted.count == textBackup.count
        let cursorHitBelowZero = formattedLengthDelta < 0
        
        if isPatternCharactedDeleted || cursorHitBelowZero {
            return currentRange
        }
        guard let positionAfterFormatting = position(from: currentRange.start, offset: formattedLengthDelta) else {
            return nil
        }
        let isPatternCharacterAdded = textMask.isPatternCharacter(atIndex: currentCursorPosition - 1, formatted: formatted)
        if isPatternCharacterAdded {
            return cursorPositionRange(positionAfterFormatting)!
        }

        return currentRange
    }
    
    private func cursorPositionRange(_ position: UITextPosition) -> UITextRange? {
        return textRange(from: position, to: position)
    }
}

extension VSTextField: StatableControl {
    
    func didChangeControlState(to: ControlState) {
        switch to {
        case .passive:
            changeFieldStateColor(style: .passive)
            changePlaceholderColor(style: .passive)
        case .focused:
            changeFieldStateColor(style: .focused)
            changePlaceholderColor(style: .focused)
        case .invalid:
            changeFieldStateColor(style: .invalid)
            changePlaceholderColor(style: .invalid)
        case .valid:
            changeFieldStateColor(style: .valid)
            changePlaceholderColor(style: .valid)
        case .locked:
            changeFieldStateColor(style: .locked)
            changePlaceholderColor(style: .locked)
        }
        
        finalizerStateChanging?()
    }
}

extension VSTextField {
    override var textInputMode: UITextInputMode? {
        return getInputMode() ?? super.textInputMode
    }
    
    private func getInputMode() -> UITextInputMode? {
        switch formatting {
        case .email, .cardHolder:
            return getInputMode(by: "en")
        case .noFormatting:
            return getInputMode(by: "ru")
        default:
            return nil
        }
    }
    
    private func getInputMode(by lang: String) -> UITextInputMode? {
        return UITextInputMode.activeInputModes
            .first(where: { $0.primaryLanguage?.contains(lang) ?? false })
    }
}

extension VSTextField {
    var maskLength: Int? {
        return (textMask as? BasicTextFieldMask)?.pattern.count
    }
}
