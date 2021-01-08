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
}

class AutoUpdateCell: UITableViewCell {
    func configure(_ item: Any) {
        if let intervalType = item as? AutoUpdateInterval {
            self.detailTextLabel?.text = intervalType.title()
            self.detailTextLabel?.textColor = UIColor.blue
            self.textLabel?.text = "Обновлять"
        }
    }
}
