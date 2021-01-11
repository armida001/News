//
//  MainTabBarController.swift
//

import UIKit

class MainTabBarController: UITabBarController, Storyboarded {
    private var storyboardName: String = "Main"
    private let news = NewsListCoordinator()
    private let settings = SettingsCoordinator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let controllers = [news.navigationController, settings.navigationController]
        if let items = self.tabBar.items {
            for (index,item) in items.enumerated() {
                controllers[index].tabBarItem = item
            }
        }
        
        viewControllers = controllers
    }
}
