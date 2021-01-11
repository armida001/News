//
//  CatalogCoordinator.swift
//  News
//

import UIKit

class NewsListCoordinator: Coordinator {
    var navigationController: CoordinatedNavigationController
    var storyboardName: String = "News"
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.coordinator = self
        
        let viewController = NewsListViewController.instantiate(storyboardName)
        viewController.coordinator = self
        navigationController.viewControllers = [viewController]
    }    
    
    func showFilter() {
    }
}
