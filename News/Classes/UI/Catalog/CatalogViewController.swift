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
        self.refresh(sender: self)
        self.view.backgroundColor = UIColor.white
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    
    @objc func refresh(sender: AnyObject) {
        dataSource.startParser {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refresh(sender: self)
    }
}
