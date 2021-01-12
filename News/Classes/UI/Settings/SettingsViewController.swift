//
//  SettingsViewController.swift
//  News
//

import UIKit
import RxSwift

final class SettingsViewController: UITableViewController, Storyboarded {
    var coordinator: SettingsCoordinator?
    private var dataSource: SettingsDataSource = SettingsDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        dataSource.showIntervalAlert = showIntervalAlert
        dataSource.showAddResourceAlert = showAddResourceAlert
        navigationController?.navigationBar.largeContentTitle = "Настройки"
        
        for (index,resource) in dataSource.resourcesArray.enumerated() {
            if resource.isActive {
                tableView.selectRow(at: IndexPath.init(row: index, section: 1), animated: false, scrollPosition: UITableView.ScrollPosition.none)
            }
        }
        
        dataSource.interval = UserDefaults.getIntervalType()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.setCustomObject(GlobalDefinition.shared.resourceItems, forKey: UserDefaultsKeys.selectedResources)
    }
    
    //MARK: Alerts
    func showIntervalAlert() {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        for i in 0...AutoUpdateInterval.none.rawValue {
            guard let autoUpdateItem = AutoUpdateInterval.init(rawValue: i) else { break }
            alert.addAction(UIAlertAction.init(title: autoUpdateItem.title(), style: UIAlertAction.Style.default, handler: { [weak self] (action) in
                self?.dataSource.interval = autoUpdateItem
                UserDefaults.setCustomObject(autoUpdateItem.rawValue, forKey: UserDefaultsKeys.updateInterval)
                self?.tableView.reloadData()
                alert.dismiss(animated: true, completion: nil)
            }))
        }
        alert.addCancelAction()
        present(alert, animated: true)
    }
    
    func showAddResourceAlert() {
        let alertController: UIAlertController = UIAlertController.init(title: "Добавить ресурс", message: nil, preferredStyle: UIAlertController.Style.alert)
        var alertTextField: UITextField?
        
        alertController.addTextField { (textField) in
            alertTextField = textField
        }
        alertController.addAction(UIAlertAction.init(title: "Добавить", style: UIAlertAction.Style.default, handler: { [weak self] _ in
            guard let `self` = self else { return }
            
            if let url = alertTextField?.text, self.verifyUrl(urlString: url) {
                GlobalDefinition.shared.resourceItems.append(ResourceItem(url: url))
                self.dataSource.resourcesArray = GlobalDefinition.shared.resourceItems
                self.tableView.reloadData()
                alertController.dismiss(animated: true, completion: nil)
            } else {
                alertController.dismiss(animated: true, completion: nil)
                self.present(UIAlertController.wrongURLErrorAlert(), animated: true)
            }
        }))
        
        alertController.addCancelAction()
        present(alertController, animated: true)
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}
