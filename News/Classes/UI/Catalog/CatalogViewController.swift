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
        self.dataSource.startParser { [weak self] in
            self?.tableView.reloadData()
        }
        self.view.backgroundColor = UIColor.white
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    
    @objc func refresh(sender: AnyObject) {
        dataSource.startParser {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }        
    }
}
