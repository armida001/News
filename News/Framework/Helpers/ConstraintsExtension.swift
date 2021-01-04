//
//  ConstraintsExtension.swift
//

import UIKit

extension NSLayoutConstraint {
    @IBInspectable var valueForiPhone5: CGFloat {
        set {
            objc_setAssociatedObject(self, &iPhone5ConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &iPhone5ConstraintKey) as? CGFloat ?? constant
        }
    }
    
    @IBInspectable var valueForiPhone6: CGFloat {
        set {
            objc_setAssociatedObject(self, &iPhone6ConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &iPhone6ConstraintKey) as? CGFloat ?? constant
        }
    }
    
    @IBInspectable var valueForiPhone6Plus: CGFloat {
        set {
            objc_setAssociatedObject(self, &iPhone6PlusConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &iPhone6PlusConstraintKey) as? CGFloat ?? constant
        }
    }
    
    @IBInspectable var valueForiPhone7: CGFloat {
        set {
            objc_setAssociatedObject(self, &iPhone7ConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &iPhone7ConstraintKey) as? CGFloat ?? constant
        }
    }
    
    @IBInspectable var valueForiPhone7Plus: CGFloat {
        set {
            objc_setAssociatedObject(self, &iPhone7PlusConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &iPhone7PlusConstraintKey) as? CGFloat ?? constant
        }
    }
    
    @IBInspectable var value : CGFloat {
        set {
            guard let deviceModel = UIDevice.current.deviceModel else {
                constant = newValue
                return
            }
            
            switch deviceModel {
            case .iPhone5, .iPhone5c, .iPhone5s:
                constant = valueForiPhone5
                break
            case .iPhone6, .iPhone6s:
                constant = valueForiPhone6
                break
            case .iPhone6Plus, .iPhone6sPlus:
                constant = valueForiPhone6Plus
                break
            case .iPhone7:
                constant = valueForiPhone7
                break
            case .iPhone7Plus:
                constant = valueForiPhone7Plus
                break
            default:
                constant = newValue
            }
        }
        get {
            return constant
        }
    }
}

private var iPhone5ConstraintKey: UInt8 = 0
private var iPhone6ConstraintKey: UInt8 = 1
private var iPhone6PlusConstraintKey: UInt8 = 2
private var iPhone7ConstraintKey: UInt8 = 3
private var iPhone7PlusConstraintKey: UInt8 = 4
