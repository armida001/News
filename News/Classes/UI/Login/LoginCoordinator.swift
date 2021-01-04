//
//  LoginCoordinator.swift
//  News
//
//  Created by 1 on 28.12.2020.
//

import UIKit

class LoginCoordinator: Coordinator {
    var splitViewController = UISplitViewController()
    var navigationController: CoordinatedNavigationController
    var storyboardName: String = "Signin"
    var completion: (()->Void)?
    
    private static let firstRunDefaultsKey = "ShownFirstRun"

    /// True when this is the first time the app has been launched.
    var isFirstRun: Bool {
        return UserDefaults.standard.bool(forKey: LoginCoordinator.firstRunDefaultsKey) == false
    }

    init() {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        self.navigationController = storyboard.instantiateViewController(withIdentifier: "LoginNavigation") as! CoordinatedNavigationController
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.coordinator = self

        let viewController = LoginViewController.instantiate(storyboardName)
        viewController.coordinator = self
        navigationController.viewControllers = [viewController]
    }
    
    func showLogin() {
        let viewController = LoginViewController.instantiate(storyboardName)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showRestore() {
        let viewController = RestoreViewController.instantiate(storyboardName)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showRegistration() {
        let viewController = RegistrationViewController.instantiate(storyboardName)
        navigationController.pushViewController(viewController, animated: true)
    }
}
