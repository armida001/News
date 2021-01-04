//
//  UINavigationBarExtension.swift
//  News
//
//  Created by 1 on 01.12.2020.
//

import Foundation
import UIKit

extension UINavigationBar {
    
    func hideNavigationBackground() {
        self.isTranslucent = true
        self.backgroundColor = UIColor.clear
        self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.shadowImage = UIImage()
    }    
}

extension UINavigationItem {
    func configBackButtonWithoutText() {
        self.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
