//
//  AutoUpdateCell.swift
//  News
//
//  Created by 1 on 09.01.2021.
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
        print(lastDate.distance(to: Date()))
        let dayTime: Double = 24 * 60 * 60
        switch self {
        case .everyDay:
            return lastDate.distance(to: Date()) > dayTime
        case .everyWeek:
            return lastDate.distance(to: Date()) > dayTime * 7
        case .everyMonth:
            return lastDate.distance(to: Date()) > dayTime * 30
        default:
            return false
        }
    }
}

class AutoUpdateCell: UITableViewCell {
    static let reusedId: String = "AutoUpdateCell"
    func configure(_ item: Any) {
        if let intervalType = item as? AutoUpdateInterval {
            self.detailTextLabel?.text = intervalType.title()
            self.textLabel?.text = "Обновлять"
        }
    }
}
