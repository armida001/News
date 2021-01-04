//
//  TimeIntervalExtension.swift
//

import UIKit

extension TimeInterval {
    var asTime: String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date(timeIntervalSince1970: self))
        return "\(components.hour ?? 00):\(components.minute ?? 00)"
    }
    
    var asDate: Date {
        return Date(timeIntervalSince1970: self)
    }
    
    static var currentHMS: TimeInterval {
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
        return Double(components.hour! * 60 * 60) + Double(components.minute! * 60) + Double(components.second!)
    }
    
    var toHMS: TimeInterval {
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: Date(timeIntervalSince1970: self))
        return Double(components.hour! * 60 * 60) + Double(components.minute! * 60) + Double(components.second!)
    }
}
