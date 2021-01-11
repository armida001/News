//
//  ResourceHeader.swift
//  News
//
//

import Foundation
import UIKit

class ResourceHeader: UITableViewCell {
    var showAddResourceAlert: (()->Void)?
    
    @IBAction func addResourceClick(_ sender: Any) {
        self.showAddResourceAlert?()
    }
}
