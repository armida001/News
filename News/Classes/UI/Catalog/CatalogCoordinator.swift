//
//  LoginCoordinator.swift
//  News
//
//  Created by 1 on 28.12.2020.
//

import UIKit

class CatalogCoordinator: Coordinator {
    var splitViewController = UISplitViewController()
    var navigationController: CoordinatedNavigationController
    var storyboardName: String = "News"
    var loginCoordinator: LoginCoordinator?
    
    private static let firstRunDefaultsKey = "ShownFirstRun"
    
    /// True when this is the first time the app has been launched.
    var isFirstRun: Bool {
        return UserDefaults.standard.bool(forKey: CatalogCoordinator.firstRunDefaultsKey) == false
    }
    
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
    
    func firstLoadIfNeed() {
//        if isFirstRun {
        if let coordinator = loginCoordinator {
            coordinator.completion = { [weak self] in
                self?.navigationController.popViewController(animated: true)
                self?.baseVC()
            }
            // Put the contents of showTour in here directly avoid trying to capture `self` during an initializer.
            self.splitViewController.present(coordinator.navigationController, animated: false)
        }
            // Mark that we've run the app at least once.
            UserDefaults.standard.set(true, forKey: CatalogCoordinator.firstRunDefaultsKey)
//        }
    }
    
    func showCatalog() {
        let viewController = LoginViewController.instantiate(storyboardName)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showFilter() {
        let viewController = RestoreViewController.instantiate(storyboardName)
        navigationController.pushViewController(viewController, animated: true)
    }
}
