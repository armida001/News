//
//  AutoUpdateCell.swift
//  News
//
//

import Foundation
import UIKit

enum AutoUpdateInterval: Int {
    case everyDay
    case everyWeek
    case everyMonth
    case none
    
    func title() -> String {
        switch self {
        case .everyDay:
            return "Ежедневно"
        case .everyWeek:
            return "Еженедельно"
        case .everyMonth:
            return "Ежемесячно"
        default:
            return "Выкл."
        }
    }
    
    func needUpdate(lastDate: Date) -> Bool {
        let interval: Double = timeInterval()
        switch self {
        case .everyDay, .everyWeek, .everyMonth:
            return lastDate.distance(to: Date()) > interval        
        default:
            return false
        }
    }
    
    func timeInterval() -> TimeInterval {
        let dayTime: Double = 24 * 60 * 60
        switch self {
        case .everyDay:
            return dayTime
        case .everyWeek:
            return dayTime * 7
        case .everyMonth:
            return dayTime * 30
        default:
            return 0
        }
    }
}

final class AutoUpdateCell: UITableViewCell {
    static let reusedId: String = "AutoUpdateCell"
    
    func configure(_ item: Any) {
        if let intervalType = item as? AutoUpdateInterval {
            detailTextLabel?.text = intervalType.title()
            textLabel?.text = "Обновлять"
        }
    }
}
