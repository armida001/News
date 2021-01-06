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
        self.baseVC()
    }
        
    func baseVC() {
        let viewController = CatalogViewController.instantiate(storyboardName)
        viewController.tabBarItem = UITabBarItem(title: "Catalog", image: UIImage(contentsOfFile: "Catalog"), tag: 0)
        viewController.coordinator = self
        navigationController.viewControllers = [viewController]
    }    
    
    func showFilter() {
    }
}
