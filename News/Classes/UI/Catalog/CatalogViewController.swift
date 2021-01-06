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
    }
}
