//
//  SettingsViewController.swift
//  News
//

import UIKit

class SettingsViewController: UITableViewController, Storyboarded {
    var coordinator: SettingsCoordinator?
    var dataSource: SettingsDataSource = SettingsDataSource()              
    
    func showAddResourceAlert() {
        let alertController: UIAlertController = UIAlertController.init(title: "Добавить ресурс", message: nil, preferredStyle: UIAlertController.Style.alert)
        var alertTextField: UITextField?
        
        alertController.addTextField { (textField) in
            alertTextField = textField
        }
        alertController.addAction(UIAlertAction.init(title: "Добавить", style: UIAlertAction.Style.default, handler: { [weak self] _ in
            if let url = alertTextField?.text {
                GlobalDefinition.shared.resourceItems.append(ResourceItem(url: url))
                self?.dataSource.resourcesArray = GlobalDefinition.shared.resourceItems
                self?.tableView.reloadData()
                alertController.dismiss(animated: true, completion: nil)
            }
        }))
        
        alertController.addAction(UIAlertAction.init(title: "Отмена", style: UIAlertAction.Style.cancel, handler: { _ in
            alertController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
        dataSource.showIntervalAlert = self.showIntervalAlert
        dataSource.showAddResourceAlert = self.showAddResourceAlert
        self.navigationController?.navigationBar.largeContentTitle = "Настройки"
    }
    
    func showIntervalAlert() {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        for i in 0...AutoUpdateInterval.none.rawValue {
            guard let autoUpdateItem = AutoUpdateInterval.init(rawValue: i) else { break }
            alert.addAction(UIAlertAction.init(title: autoUpdateItem.title(), style: UIAlertAction.Style.default, handler: { [weak self] (action) in
                self?.dataSource.interval = autoUpdateItem
                self?.tableView.reloadData()
                alert.dismiss(animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction.init(title: "Отменить", style: UIAlertAction.Style.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.setCustomObject(GlobalDefinition.shared.resourceItems, forKey: UserDefaultsKeys.selectedResources)
    }
}
