//
//  MaterialTextField.swift
//  GiftClub
//
//  Created by Nikolay Churyanin on 17.01.18.
//  Copyright © 2018 simbirsoft. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MaterialTextField: UIView {
    @IBOutlet internal var contentView: UIView!
    @IBOutlet internal weak var abovePlaceholderLabel: UILabel!
    @IBOutlet internal weak var mainPlaceHolderLabel: UILabel!
    @IBOutlet internal weak var mainTextField: VSTextField!
    @IBOutlet internal weak var rightImageView: UIImageView!
    @IBOutlet weak var widthRightImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightRightImageConstraint: NSLayoutConstraint!
    @IBOutlet internal var selfTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var aboveLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var topHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldBottomViewHConstrainst: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
        bindings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
        bindings()
    }
    
    internal func commonInit() {
        _ = UINib(nibName: "MaterialTextField",bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        configurePlaceHolderColor()
    }
    
    internal func configurePlaceHolderColor() {
        mainTextField.finalizerStateChanging = { [weak self] in
            self?.mainTextField.placeholderColor = UIColor.color_33_40_50
        }
    }
    
    internal func bindings() {
        mainTextField.rx
            .controlEvent(.editingDidBegin)
            .bind { [weak self]  in
                self?.abovePlaceholderLabel.isHidden = false
                self?.mainPlaceHolderLabel.isHidden = true
            }.disposed(by: disposeBag)
        
        selfTapGesture.rx.event
            .bind(onNext: { [weak self] _ in
                self?.mainTextField.becomeFirstResponder()
            }).disposed(by: disposeBag)
        
        mainTextField.rx.controlEvent(.editingDidEnd)
            .map { [weak self] _ -> Bool in
                guard let `self` = self else { return false }
                return self.text.isEmpty && self.innerPlaceholder.trimmingCharacters(in: .whitespaces).isEmpty
            }.subscribe(onNext: { [weak self] isEmpty in
                self?.abovePlaceholderLabel.isHidden = isEmpty
                self?.mainPlaceHolderLabel.isHidden = !isEmpty
            }).disposed(by: disposeBag)
    }
    
    internal lazy var disposeBag = DisposeBag()
    
    func addMainLabelTrailingConstrainst() {
        self.mainPlaceHolderLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0).isActive = true
    }
}

@objc extension MaterialTextField {
    @IBInspectable
    var editable: Bool {
        get {
            return selfTapGesture.isEnabled
        }
        set {
            selfTapGesture.isEnabled = newValue
            mainTextField.isEnabled = newValue
        }
    }
    
    @IBInspectable
    var innerPlaceholder: String {
        get {
            return mainTextField.placeholder ?? ""
        }
        set {
            mainPlaceHolderLabel.isHidden = true
            abovePlaceholderLabel.isHidden = false
            mainTextField.placeholder = newValue
        }
    }
    
    @IBInspectable
    var plcaceholderLocalize: String? {
        get {
            return mainPlaceHolderLabel.text
        }
        set {
            if let newValue = newValue {
                mainPlaceHolderLabel.text = newValue
                abovePlaceholderLabel.text = newValue
            }
        }
    }
    
    @IBInspectable
    var text: String {
        get {
            return mainTextField.text ?? ""
        }
        set {
            mainPlaceHolderLabel.isHidden = !newValue.isEmpty
            abovePlaceholderLabel.isHidden = newValue.isEmpty
            mainTextField.text = newValue
        }
    }
    
    @IBInspectable
    var rightImage: UIImage? {
        get {
            return rightImageView.image
        }
        set {
            rightImageView.image = newValue
        }
    }
    
    @IBInspectable
    var rightImageWidth: CGFloat {
        get {
            return rightImageView.frame.width
        }
        set {
            widthRightImageConstraint.constant = newValue
            heightRightImageConstraint.constant = newValue
        }
    }

    var returnKeyType: UIReturnKeyType {
        get {
            return mainTextField.returnKeyType
        }
        set {
            mainTextField.returnKeyType = newValue
        }
    }
    
    var textColor: UIColor? {
        get {
            return mainTextField.textColor
        }
        set {
            mainTextField.textColor = newValue
        }
    }
    
    var isValid: Bool {
        return mainTextField.isValid
    }
    
    @nonobjc var finalizerValidation: ((Bool?) -> ())? {
        get {
            return mainTextField.finalizerValidation
        }
        set {
            mainTextField.finalizerValidation = newValue
        }
    }
    
    @nonobjc var rxText: Observable<String?> {
        return mainTextField.rx.text.asObservable()
    }
    
    override func becomeFirstResponder() -> Bool {
        return mainTextField.becomeFirstResponder()
    }
    
    @nonobjc func setFormattingType(formatting: TextFieldFormatting) {
        mainTextField.setFormattingType(formatting: formatting)
    }
    
    func setExternalValidation(_ validation: @escaping(()->(Bool))) {
        mainTextField.externalValidation = validation
    }
    
    func shouldReturn(handler: @escaping (()->(Bool))) {
        return mainTextField.rx.shouldReturn(handler: handler)
    }
    
    func didEndEditing(handler: @escaping (()->())) {
        return mainTextField.rx.didEndEditing(handler: handler)
    }
    
    func didBeginEditing(handler: @escaping (()->())) {
        return mainTextField.rx.didBeginEditing(handler: handler)
    }
}

extension MaterialTextField {
    var didFilled: Observable<Void> {
        return mainTextField.rx.text
            .distinctUntilChanged {(x, y) -> Bool in
                guard let old = x, let new = y else { return false }
                return old.elementsEqual(new)
            }.filter { [weak self] text in
                guard let text = text,
                    let count = self?.mainTextField.maskLength else { return false }
                
                return (text.count == count)
            }.map { _ in () }
    }
    
    func configureClearing() {
        mainTextField.rx.changeInRangeWithString { [weak self] range, string in
            guard let `self` = self,
                let count = self.mainTextField.maskLength else { return false }
            
            let fieldIsFilled = range.location >= count
            let willRemoveLastSymbol = (range.location == (count - 1) && range.length == 1)
            
            if  fieldIsFilled || willRemoveLastSymbol {
                self.mainTextField.text = string
                return false
            }
            
            return true
        }
    }
}

extension Reactive where Base: MaterialTextField {
    var text: UIBindingObserver<Base, String> {
        return UIBindingObserver(UIElement: base) { control, text in
            control.text = text
        }
    }
}
