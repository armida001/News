//
//  MainTabBarController.swift
//

import UIKit

class MainTabBarController: UITabBarController, Storyboarded {
    var storyboardName: String = "Main"
    let catalog = NewsListCoordinator()
    let settings = SettingsCoordinator()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = self.tabBar.items, items.count > 1 {
            catalog.navigationController.tabBarItem = items.first
            settings.navigationController.tabBarItem = items[1]
        }
        viewControllers = [catalog.navigationController, settings.navigationController]        
    }
    
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
