//
//  DataExtension.swift
//  GiftClub
//
//  Created by Nikolay Churyanin on 07.02.18.
//  Copyright © 2018 simbirsoft. All rights reserved.
//

import Foundation

extension Data {
    var errorMessage: String? {
        return String(data: self, encoding: .utf8)
    }
}

extension Date {
    static var tomorrow:  Date { return Date().dayAfter }

    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
}
