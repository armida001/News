//
//  NewsCell.swift
//  News
//

import Foundation
import UIKit
import Kingfisher

class ResourceCell: UITableViewCell {
    static let reusedId = "ResourceCell"
    var item: ResourceItem?
    
    func configure(_ item: Any) {
        self.item = item as? ResourceItem
        if let nItem = self.item {
            self.textLabel?.text = nItem.url?.absoluteString ?? ""
            self.textLabel?.adjustsFontSizeToFitWidth = true
            self.accessoryType = nItem.isActive ? .checkmark : .none
        }
    }
}
