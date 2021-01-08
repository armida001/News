//
//  ResourceHeader.swift
//  News
//
//  Created by 1 on 08.01.2021.
//

import Foundation
import UIKit

class ResourceHeader: UITableViewCell {
    var showAddResourceAlert: (()->Void)?
    
    @IBAction func addResourceClick(_ sender: Any) {
        self.showAddResourceAlert?()
    }
}
