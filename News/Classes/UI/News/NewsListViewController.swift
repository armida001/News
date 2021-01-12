//
//  CatalogViewController.swift
//  News
//

import UIKit

final class NewsListViewController: UITableViewController, Storyboarded {
    var coordinator: NewsListCoordinator?
    private var dataSource: NewsListDataSource = NewsListDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        view.backgroundColor = UIColor.white
        refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        let intervalType = UserDefaults.getIntervalType()
        if intervalType != AutoUpdateInterval.none {
            refresh(sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        autoUpdateIfNeed()
    }
    
    //MARK: Reloading
    func autoUpdateIfNeed() {
        let intervalType = UserDefaults.getIntervalType()
        let lastUpdateDate = UserDefaults.getCustomObject(forKey: UserDefaultsKeys.lastUpdate) as? Date
        
        if lastUpdateDate == nil {
            refresh(sender: self)
        } else
        if intervalType != AutoUpdateInterval.none, let lastUpdateDate = UserDefaults.getCustomObject(forKey: UserDefaultsKeys.lastUpdate) as? Date, intervalType.needUpdate(lastDate: lastUpdateDate) {
            refresh(sender: self)
        }
    }
    
    @objc func refresh(sender: AnyObject) {
        dataSource.newsArray.removeAll()
        tableView.reloadData()
        dataSource.startParser {[weak self] in
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
            UserDefaults.setCustomObject(Date(), forKey: UserDefaultsKeys.lastUpdate)
        }        
    }
}
