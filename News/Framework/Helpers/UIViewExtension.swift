//
//  UIViewExtension.swift
//  iOS-Platform
//
//  Created by Andrey Chernyshev on 17.11.16.
//  Copyright © 2016 simbirsoft. All rights reserved.
//

import UIKit

extension UIView {
    
    public static var defaultNib: UINib {
        return UINib(nibName: defaultNibName, bundle: nil)
    }
    
    public static var defaultNibName: String {
        return String(describing: self)
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let `borderColor` = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: borderColor)
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var maskToBounds: Bool {
        set {
            layer.masksToBounds = newValue
        }
        get {
            return layer.masksToBounds
        }
    }
    
    @IBInspectable var isTranslatesAutoresizingMaskIntoConstraints: Bool {
        set {
            translatesAutoresizingMaskIntoConstraints = newValue
        }
        get {
            return translatesAutoresizingMaskIntoConstraints
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        set {
            layer.shadowOffset = newValue
        }
        get {
            return layer.shadowOffset
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue?.cgColor
        }
        get {
            return layer.shadowColor == nil ? nil : UIColor(cgColor:layer.shadowColor!)
        }
    }
    
    func animateShowAndHideView(topViewConstraint: NSLayoutConstraint, baseView: UIView) {
        if self.isHidden {
            self.isHidden = false
            UIView.animate(withDuration: 0.7,
                           delay: 0.0,
                           usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 0.0,
                           options: UIView.AnimationOptions(rawValue: 0),
                           animations: {
                            topViewConstraint.constant = 0
                            baseView.layoutIfNeeded()
            },
                           completion: { animate in
                            UIView.animate(withDuration: 0.7,
                                           delay: 0.5,
                                           usingSpringWithDamping: 1.0,
                                           initialSpringVelocity: 0.0,
                                           options: UIView.AnimationOptions(rawValue: 0),
                                           animations: {
                                            topViewConstraint.constant = -40
                                            baseView.layoutIfNeeded()
                            },
                                           completion: { animate in
                                            self.isHidden = true
                            })
            })
        }
    }
    
    func configureBottomShadow(shadowColor: UIColor = UIColor.black, shadowRadius: CGFloat = 20.0, shadowOpacity: Float = 0.07, shadowOffset: CGSize = CGSize(width: 0, height: 10)) {
        self.borderWidth = 1
        self.borderColor = UIColor.clear
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
        self.shadowOffset = shadowOffset
    }
    
    func cornerShadow(_ cornerRadius: CGFloat = 28, color: UIColor) {
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        layer.shadowRadius = 7
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = color.cgColor
    }
    
    func fixInView(_ container: UIView, top: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(self)
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: left).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: right * (-1)).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: top).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: bottom * (-1)).isActive = true
    }
}
