//
//  Protocols.swift
//  News
//
//  Created by 1 on 28.12.2020.
//

import UIKit

/// Used to dictate the basics of all coordinators in the app.
protocol Coordinator: AnyObject {
//    var navigationController: CoordinatedNavigationController { get set }
    var splitViewController: UISplitViewController { get set }
    var storyboardName: String { get set }
}
