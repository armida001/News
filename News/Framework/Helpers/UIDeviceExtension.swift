//
//  UIDeviceExtension.swift
//  BrightLive
//
//  Created by Andrey Chernyshev on 27.01.17.
//  Copyright © 2017 simbirsoft. All rights reserved.
//

import UIKit

enum DeviceModel: String {
    case iPodTouch5
    case iPodTouch6
    case iPhone4
    case iPhone4s
    case iPhone5
    case iPhone5c
    case iPhone5s
    case iPhone6
    case iPhone6Plus
    case iPhone6s
    case iPhone6sPlus
    case iPhone7
    case iPhone7Plus
    case iPhoneSE
    case iPhone8
    case iPhone8Plus
    case iPhoneX
    case iPad2
    case iPad3
    case iPad4
    case iPadAir
    case iPadAir2
    case iPadMini
    case iPadMini2
    case iPadMini3
    case iPadMini4
    case iPadPro
    case AppleTV
    case Simulator
}

extension UIDevice {
    var deviceModel: DeviceModel? {
        var systemInfo = utsname()
        uname(&systemInfo)
        let identifier = Mirror(reflecting: systemInfo.machine).children.reduce("") { (identifier, element) in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
            case "iPod5,1":                                 return DeviceModel.iPodTouch5
            case "iPod7,1":                                 return DeviceModel.iPodTouch6
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return DeviceModel.iPhone4
            case "iPhone4,1":                               return DeviceModel.iPhone4s
            case "iPhone5,1", "iPhone5,2":                  return DeviceModel.iPhone5
            case "iPhone5,3", "iPhone5,4":                  return DeviceModel.iPhone5c
            case "iPhone6,1", "iPhone6,2":                  return DeviceModel.iPhone5s
            case "iPhone7,2":                               return DeviceModel.iPhone6
            case "iPhone7,1":                               return DeviceModel.iPhone6Plus
            case "iPhone8,1":                               return DeviceModel.iPhone6s
            case "iPhone8,2":                               return DeviceModel.iPhone6sPlus
            case "iPhone9,1", "iPhone9,3":                  return DeviceModel.iPhone7
            case "iPhone9,2", "iPhone9,4":                  return DeviceModel.iPhone7Plus
            case "iPhone8,4":                               return DeviceModel.iPhoneSE
            case "iPhone10,1", "iPhone10,4":                return DeviceModel.iPhone8
            case "iPhone10,2", "iPhone10,5":                return DeviceModel.iPhone8Plus
            case "iPhone10,3", "iPhone10,6":                return DeviceModel.iPhoneX
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return DeviceModel.iPad2
            case "iPad3,1", "iPad3,2", "iPad3,3":           return DeviceModel.iPad3
            case "iPad3,4", "iPad3,5", "iPad3,6":           return DeviceModel.iPad4
            case "iPad4,1", "iPad4,2", "iPad4,3":           return DeviceModel.iPadAir
            case "iPad5,3", "iPad5,4":                      return DeviceModel.iPadAir2
            case "iPad2,5", "iPad2,6", "iPad2,7":           return DeviceModel.iPadMini
            case "iPad4,4", "iPad4,5", "iPad4,6":           return DeviceModel.iPadMini2
            case "iPad4,7", "iPad4,8", "iPad4,9":           return DeviceModel.iPadMini3
            case "iPad5,1", "iPad5,2":                      return DeviceModel.iPadMini4
            case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return DeviceModel.iPadPro
            case "AppleTV5,3":                              return DeviceModel.AppleTV
            case "i386", "x86_64":                          return DeviceModel.Simulator
            default:                                        return nil
        }
    }
    
    static func deviceUID() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
}
