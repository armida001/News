//
//  MainTabBarController.swift
//  Unwrap
//

import UIKit

/// A UITabBarController subclass that sets up our main coordinators as each of the five app tabs.
class MainTabBarController: UITabBarController, Storyboarded {
    var storyboardName: String = "Main"
//    let login = LoginCoordinator()
    let catalog = CatalogCoordinator()
//    let profile = ProfileCoordinator()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [catalog.navigationController]//, profile.splitViewController]
    }
    
    /// If we get some launch options, figure out which one was requested and jump right to the correct tab.
    func handle(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        if let item = launchOptions?[.shortcutItem] as? UIApplicationShortcutItem {
            handle(shortcutItem: item)
        }
    }

    func handle(shortcutItem: UIApplicationShortcutItem) {
        selectedViewController = catalog.splitViewController
//        switch shortcutItem.type {
//        case "com.hackingwithswift.unwrapswift.challenges":
//            selectedViewController = challenges.splitViewController
//        case "com.hackingwithswift.unwrapswift.news":
//            selectedViewController = news.splitViewController
//        default:
//            fatalError("Unknown shortcut item type: \(shortcutItem.type).")
//        }
    }
}
