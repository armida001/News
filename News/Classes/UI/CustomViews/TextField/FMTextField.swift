//
//  FMTextField.swift
//  News
//
//  Created by 1 on 01.12.2020.
//

import Foundation
import UIKit

class FMTextField: MaterialTextField {
    let fontName = "Helvetica Neue"
    let fontSize: CGFloat = 17.0
    
    override func commonInit() {
        super.commonInit()
        
        let baseFont = UIFont.init(name: fontName, size: fontSize)
        
        self.mainTextField.textColor = UIColor.color_33_40_50
        self.mainTextField.setDefaultColor(color: UIColor.color_33_40_50)
        self.mainTextField.font = baseFont
        
        self.contentView.borderColor = UIColor.color_33_40_50
        self.contentView.borderWidth = 1
        self.contentView.cornerRadius = 5
        
        self.abovePlaceholderLabel.font = UIFont.init(name: fontName, size: 12)
        self.mainPlaceHolderLabel.font = baseFont
        self.abovePlaceholderLabel.textColor = UIColor.color_33_40_50.withAlphaComponent(0.8)
        self.mainPlaceHolderLabel.textColor = UIColor.color_33_40_50
    }
}
