//
//  LoginCoordinator.swift
//  News
//

import UIKit

class SettingsCoordinator: Coordinator {
    var splitViewController = UISplitViewController()
    var navigationController: CoordinatedNavigationController
    var storyboardName: String = "News"
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.coordinator = self
        
        let viewController = SettingsViewController.instantiate(storyboardName)
        viewController.coordinator = self
        navigationController.viewControllers = [viewController]
    }
    
    func showFilter() {
        let viewController = SettingsViewController.instantiate(storyboardName)
        navigationController.pushViewController(viewController, animated: true)
    }
}
