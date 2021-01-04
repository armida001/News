//
//  ColorExtension.swift
//  FLAT
//
//  Created by Andrey Chernyshev on 15.02.17.
//  Copyright © 2017 Andrey Chernyshev. All rights reserved.
//

import UIKit

extension UIColor {
    @nonobjc
    static var color_33_40_50: UIColor {
        return UIColor(named: "Color") ?? UIColor(red: 33/255, green: 40/255, blue: 50/255, alpha: 1)
    }
    
    @nonobjc
    static var color_77_170_179: UIColor {
        return UIColor(named: "Background") ?? UIColor(red: 77/255, green: 170/255, blue: 179/255, alpha: 1)
    }
    
    @nonobjc
    static var color_58_61_69: UIColor {
        return UIColor(named: "ButtonBackground") ?? UIColor(red: 58/255, green: 61/255, blue: 69/255, alpha: 1)
    }
}
