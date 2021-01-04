//
//  LoginCoordinator.swift
//  News
//
//  Created by 1 on 28.12.2020.
//

import UIKit

class ProfileCoordinator: Coordinator {
    var splitViewController = UISplitViewController()
    var navigationController: CoordinatedNavigationController
    var storyboardName: String = "Profile"

    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.coordinator = self

        self.baseVC()
    }
    
    func baseVC() {
        let viewController = ProfileViewController.instantiate(storyboardName)
        viewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(contentsOfFile: "Profile"), tag: 1)
        viewController.coordinator = self
        navigationController.viewControllers = [viewController]
    }
    
    func showCatalog() {
        let viewController = ProfileViewController.instantiate(storyboardName)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showFilter() {
        let viewController = RestoreViewController.instantiate(storyboardName)
        navigationController.pushViewController(viewController, animated: true)
    }
}
