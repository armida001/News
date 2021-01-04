//
//  UILabelExtension.swift
//

import UIKit

extension UILabel {
    var numberOfTextLines: Int {
        return self.numberOfTextLines(width: frame.size.width)
    }
    
    func numberOfTextLines(width: CGFloat) -> Int {
        guard let textValue = text else { return 0}
        let textSize = CGSize(width: CGFloat(width-5), height: .greatestFiniteMagnitude)
        let labelSize = textValue.boundingRect(with: textSize, options: [.usesLineFragmentOrigin], attributes: [.font: font as Any], context: nil)
        let charSize = lroundf(Float(font.lineHeight))
        return lroundf(Float(labelSize.height) / Float(charSize))
    }
    
    func setCenteredAdjustsFontSizeToFitWidth(_ value: Bool) {        
        self.adjustsFontSizeToFitWidth = value
        if value {
            self.baselineAdjustment = .alignCenters
        }
    }
}
