//
//  CatalogViewController.swift
//  News
//

import UIKit

class CatalogViewController: UITableViewController, Storyboarded {
    var coordinator: CatalogCoordinator?
    var dataSource: CatalogDataSource = CatalogDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
        self.view.backgroundColor = UIColor.white
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        autoUpdateIfNeed()
    }
    
    func autoUpdateIfNeed() {
        let intervalType = UserDefaults.getIntervalType()
        let lastUpdateDate = UserDefaults.getCustomObject(forKey: UserDefaultsKeys.lastUpdate) as? Date
        
        if lastUpdateDate == nil {
            refresh(sender: self)
        } else
        if intervalType != AutoUpdateInterval.none, intervalType.needUpdate(lastDate: lastUpdateDate!) {
            refresh(sender: self)
        }
    }
    
    @objc func refresh(sender: AnyObject) {
        dataSource.startParser {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            UserDefaults.setCustomObject(Date(), forKey: UserDefaultsKeys.lastUpdate)
        }        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.autoUpdateIfNeed()
    }
}
