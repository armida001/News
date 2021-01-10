//
//  DateExtension.swift
//  FLAT
//
//  Created by Andrey Chernyshev on 16.02.17.
//  Copyright © 2017 Andrey Chernyshev. All rights reserved.
//

import UIKit

extension Date {
    static func daysBetweenDates(first: Date, second: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: first, to: second).day ?? 0
    }
    
    static func hoursBetweenDates(first: Date, second: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: first, to: second).hour ?? 0
    }
    
    static func minutesBetweenDates(first: Date, second: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: first, to: second).minute ?? 0
    }
    
    static func numberDayInMonth(month: Int, year: Int) -> Int {
        var components = DateComponents()
        components.year = year
        components.month = month
        return Calendar.current.range(of: .day, in: .month, for: components.date ?? Date())?.count ?? 0
    }
    
    static func defaultFormatString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter.string(from: date)
    }
//    
//    static func shotFormatString(from date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat =  R.string.localizable.short_dateFormat.localized()
//        formatter.locale = GlobalDefinitions.currentLocale
//        return formatter.string(from: date)
//    }
//    
//    static func timeFormatString(from date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        formatter.locale = GlobalDefinitions.currentLocale
//        return formatter.string(from: date)
//    }
//    
//    static func dateAndTimeFormatString(from date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd MMMM, HH:mm"
//        formatter.locale = GlobalDefinitions.currentLocale
//        return formatter.string(from: date)
//    }
//    
//    static func dateFormatString(from date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd MMMM"
//        formatter.locale = GlobalDefinitions.currentLocale
//        return formatter.string(from: date)
//    }
//    
//    static func dateAndTimeFormatForJSON(from date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = R.string.localizable.delivery_date_time_formater.localized()
//        formatter.locale = GlobalDefinitions.currentLocale
//        return formatter.string(from: date)
//    }
}
