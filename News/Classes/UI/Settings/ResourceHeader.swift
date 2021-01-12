//
//  ResourceHeader.swift
//  News
//
//

import Foundation
import UIKit

final class ResourceHeader: UITableViewCell {
    var showAddResourceAlert: (()->Void)?
    
    @IBAction func addResourceClick(_ sender: Any) {
        showAddResourceAlert?()
    }
}
