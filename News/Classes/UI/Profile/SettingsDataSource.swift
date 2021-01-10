//
//  CatalogDataSource.swift
//  News
//

import Foundation
import UIKit

enum SectionType: Int {
    case autoUpdate = 0
    case resource
}

class SettingsDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    var resourcesArray: [ResourceItem] = GlobalDefinition.shared.resourceItems
    var interval: AutoUpdateInterval = AutoUpdateInterval.none
    var showIntervalAlert: (()->Void)?
    var showAddResourceAlert: (()->Void)?
    
    //MARK: UITableViewDelegate methods
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != SectionType.autoUpdate.rawValue {
            return 60
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != SectionType.autoUpdate.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceHeader") as? ResourceHeader else {
                return UIView.init(frame: CGRect.zero)
            }
            cell.showAddResourceAlert = self.showAddResourceAlert
            return cell
        }
        return UIView.init(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect.zero)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SectionType.autoUpdate.rawValue {
            return 1
        }
        return resourcesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SectionType.autoUpdate.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AutoUpdateCell.reusedId, for: indexPath) as? AutoUpdateCell else {
                return UITableViewCell()
            }
            cell.configure(interval)
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResourceCell.reusedId, for: indexPath) as? ResourceCell else {
            return UITableViewCell()
        }
        cell.configure(resourcesArray[indexPath.row])        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ResourceCell {
            cell.accessoryType = .none
            if let resource = cell.item {
                cell.item?.isActive = false
                GlobalDefinition.shared.resourceItems.first(where: {$0.hashId == resource.hashId})?.isActive = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SectionType.autoUpdate.rawValue {
            self.showIntervalAlert?()
        } else if let cell = tableView.cellForRow(at: indexPath) as? ResourceCell {
            cell.accessoryType = .checkmark
            if let resource = cell.item {
                cell.item?.isActive = true
                GlobalDefinition.shared.resourceItems.first(where: {$0.hashId == resource.hashId})?.isActive = true
            }
        }
    }
}
