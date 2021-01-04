//
//  RxUITextFieldDelegate.swift
//  GiftClub
//
//  Created by Nikolay Churyanin on 25.01.18.
//  Copyright © 2018 simbirsoft. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITextField {
    func changeInRangeWithString(handler: ((NSRange, String)->(Bool))?) {
        return (delegate as! RxUITextFieldDelegateProxy).changeInRangeWithString = handler
    }
    
    func shouldReturn(handler: @escaping (()->(Bool))) {
        return (delegate as! RxUITextFieldDelegateProxy).shouldReturn = handler
    }
    
    func didEndEditing(handler: @escaping(()->())) {
        return (delegate as! RxUITextFieldDelegateProxy).didEndEditing = handler
    }
    
    func didBeginEditing(handler: @escaping(()->())) {
        return (delegate as! RxUITextFieldDelegateProxy).didBeginEditing = handler
    }
    
    private var delegate: DelegateProxy<UITextField, UITextFieldDelegate> {
        return RxUITextFieldDelegateProxy.proxy(for: base)
    }
}

private class RxUITextFieldDelegateProxy: DelegateProxy<UITextField, UITextFieldDelegate>, DelegateProxyType, UITextFieldDelegate {
    var changeInRangeWithString: ((NSRange, String)->(Bool))? = nil
    var shouldReturn: (()->(Bool))? = nil
    var didEndEditing: (()->())? = nil
    var didBeginEditing: (()->())? = nil
    
    public weak private(set) var localAnyObject: AnyObject?
    
    init(localAnyObject: ParentObject) {
        self.localAnyObject = localAnyObject
        super.init(parentObject: localAnyObject, delegateProxy: RxUITextFieldDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register{ RxUITextFieldDelegateProxy(localAnyObject: $0) }
    }
    
    static func currentDelegate(for object: UITextField) -> UITextFieldDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: UITextFieldDelegate?, to object: UITextField) {
        object.delegate = delegate
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return changeInRangeWithString?(range, string) ?? true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return shouldReturn?() ?? true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layoutIfNeeded()
        didEndEditing?()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        didBeginEditing?()
    }
}
