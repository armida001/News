//
//  Protocols.swift
//  News
//

import UIKit

/// Used to dictate the basics of all coordinators in the app.
protocol Coordinator: AnyObject {
    var splitViewController: UISplitViewController { get set }
    var storyboardName: String { get set }
}
