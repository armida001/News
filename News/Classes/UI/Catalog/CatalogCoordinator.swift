//
//  CatalogCoordinator.swift
//  News
//

import UIKit

class CatalogCoordinator: Coordinator {
    var splitViewController = UISplitViewController()
    var navigationController: CoordinatedNavigationController
    var storyboardName: String = "News"
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.coordinator = self
        
        let viewController = CatalogViewController.instantiate(storyboardName)
        viewController.coordinator = self
        navigationController.viewControllers = [viewController]
    }    
    
    func showFilter() {
    }
}
