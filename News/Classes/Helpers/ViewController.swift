//
//  ViewController.swift
//  News
//
//  Created by 1 on 24.11.2020.
//

import UIKit

struct ViewControllers {
    static let initialIdentifier: String = "*"
    static func initial<T: UIViewController>(of storyboardName: String) -> ViewController<T> {
        return ViewController(storyboardName: storyboardName, identifier: initialIdentifier)
    }
    
    // To prevent instancing. This struct is used as namespace
    private init() { }
}

struct ViewController<T: UIViewController>: ExpressibleByStringLiteral, Equatable {
    let storyboard: UIStoryboard
    let identifier: String
    
    func instantiate(setup: ((T) -> Void)? = nil) -> T {
        guard identifier != ViewControllers.initialIdentifier else {
            guard let viewController = storyboard.instantiateInitialViewController() as? T else {
                fatalError("Failed to instantiate initial view controller as \(T.self) type")
            }

            return viewController
        }

        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Failed to instantiate view controller \(identifier) as \(T.self) type")
        }
        
        setup?(viewController)

        return viewController
    }
    
    func instantiate<U: UIViewControllerContainer>(in container: U.Type, setup: ((T) -> Void)? = nil) -> U {
        return U.container(with: self.instantiate(setup: setup))
    }
    
    init(storyboardName: String, identifier: String) {
        self.storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        self.identifier = identifier
    }
    
    init(_ value: String) {
        let parts: [String] = value.split(separator: ".", maxSplits: 2, omittingEmptySubsequences: true).map(String.init)
        
        let storyboardName: String
        let identifier: String
        
        switch parts.count {
        case 2:
            storyboardName = parts.first!
            identifier = parts.last!
        case 1:
            storyboardName = "Main"
            identifier = parts.last!
        default:
            fatalError("Invalid UIViewController identifier")
        }
        
        self.init(storyboardName: storyboardName, identifier: identifier)
    }
    
    init(stringLiteral value: String) {
        self.init(value)
    }
    
    init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    static func == (lhs: ViewController, rhs: ViewController) -> Bool {
        return (lhs.storyboard == rhs.storyboard) && (lhs.identifier == rhs.identifier)
    }
}

protocol ViewControllerDelegate: class {
    func setRoot<T>(_ viewController: ViewController<T>, in window: UIWindow?, options: UIView.AnimationOptions, setup: ((T) -> Void)?) -> Bool
    func replace<T>(with viewController: ViewController<T>, animated: Bool, wholeStack: Bool, setup: ((T) -> Void)?) -> Bool
    func show<T>(_ viewController: ViewController<T>, sender: Any?, setup: ((T) -> Void)?)
    func showDetail<T>(_ viewController: ViewController<T>, sender: Any?, setup: ((T) -> Void)?)
    func present<T>(_ viewController: ViewController<T>, animated: Bool, completion: (() -> Void)?, setup: ((T) -> Void)?)
    
    func show(_ viewController: UIViewController, sender: Any?)
    func showDetail(_ viewController: UIViewController, sender: Any?)
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
}

extension ViewControllerDelegate {
    func show<T>(_ viewController: ViewController<T>, sender: Any? = nil, setup: ((T) -> Void)?) {
        self.show(viewController, sender: sender, setup: setup)
    }
    
    func showDetail<T>(_ viewController: ViewController<T>, sender: Any? = nil, setup: ((T) -> Void)?) {
        self.showDetail(viewController, sender: sender, setup: setup)
    }
    
    func present<T>(_ viewController: ViewController<T>, animated: Bool, completion: (() -> Void)? = nil, setup: ((T) -> Void)? = nil) {
        self.present(viewController, animated: animated, completion: completion, setup: setup)
    }
}

extension UIViewController: ViewControllerDelegate {
    // MARK: - Set root
    @discardableResult
    func setRoot<T>(_ viewController: ViewController<T>, in window: UIWindow? = nil, options: UIView.AnimationOptions = [.curveEaseInOut, .preferredFramesPerSecond60], setup: ((T) -> Void)? = nil) -> Bool {
        guard let window = window ?? self.view.window else { return false }
        return window.setRoot(viewController, setup: setup)
    }
    
    @discardableResult
    func setLoginAsRoot(in window: UIWindow? = nil, setup: ((UIViewController) -> Void)? = nil) -> Bool {
        return setRoot(ViewControllers.initial(of: "Login"), in: window, setup: setup)
    }
    
    @discardableResult
    func setMainAsRoot(in window: UIWindow? = nil, setup: ((UIViewController) -> Void)? = nil) -> Bool {
        return setRoot(ViewControllers.initial(of: "Main"), in: window, setup: setup)
    }
    @discardableResult
    func setDashboardAsRoot(in window: UIWindow? = nil, setup: ((UIViewController) -> Void)? = nil) -> Bool {
        return setRoot(ViewControllers.initial(of: "Dashboard"), in: window, setup: setup)
    }
    
    // MARK: - Replace
    @discardableResult
    func replace<T>(with viewController: ViewController<T>, animated: Bool, wholeStack: Bool, setup: ((T) -> Void)? = nil) -> Bool {
        guard let navigationController = self.navigationController else {
            return false
        }
        let replacement = viewController.instantiate(setup: setup)
        
        let newStack: [UIViewController]
        if wholeStack {
            newStack = [replacement]
        } else {
            newStack = navigationController.viewControllers.map({
                guard $0 == self else { return $0 }
                return replacement
            })
        }
        
        navigationController.setViewControllers(newStack, animated: animated)
        return true
    }
    
    // MARK: - Show
    
    func show<T>(_ viewController: ViewController<T>, sender: Any? = nil, setup: ((T) -> Void)? = nil) {
        let instance = viewController.instantiate(setup: setup)
        self.show(instance, sender: sender)
    }
    
    func showDetail<T>(_ viewController: ViewController<T>, sender: Any? = nil, setup: ((T) -> Void)? = nil) {
        let instance = viewController.instantiate(setup: setup)
        self.showDetailViewController(instance, sender: sender)
    }
    
    func present<T>(_ viewController: ViewController<T>, animated: Bool, completion: (() -> Void)? = nil, setup: ((T) -> Void)? = nil) {
        let instance = viewController.instantiate(setup: setup)
        self.present(instance, animated: animated, completion: completion)
    }
    
    func showDetail(_ viewController: UIViewController, sender: Any?) {
        self.showDetailViewController(viewController, sender: sender)
    }
}

extension UIWindow {
    @discardableResult
    func setRoot<T>(_ viewController: ViewController<T>, options: UIView.AnimationOptions = [.curveEaseInOut, .preferredFramesPerSecond60], setup: ((T) -> Void)? = nil) -> Bool {
        let newRoot = viewController.instantiate(setup: setup)
//        guard rootViewController.flatMap({type(of: $0) != type(of: newRoot)}) ?? true else {
//            if let oldRoot = rootViewController as? T {
//                setup?(oldRoot)
//            }
//            return false
//        }
        
        UIView.transition(
            with: self,
            duration: 2 * CATransaction.animationDuration(),
            options: options,
            animations: { [weak self] in
                self?.rootViewController = newRoot
            },
            completion: { _ in
            }
        )
        
        return true
    }
    
    @discardableResult
    func setLoginAsRoot(setup: ((UIViewController) -> Void)? = nil) -> Bool {
        return setRoot(ViewControllers.initial(of: "Login"), setup: setup)
    }
    
    @discardableResult
    func setWatchlistAsRoot(setup: ((UIViewController) -> Void)? = nil) -> Bool {
        return setRoot(ViewControllers.initial(of: "Watchlist"), setup: setup)
    }
    
    @discardableResult
    func setMainAsRoot(setup: ((UIViewController) -> Void)? = nil) -> Bool {
        return setRoot(ViewControllers.initial(of: "Main"), setup: setup)
    }
}

protocol UIViewControllerContainer where Self: UIViewController {
    static func container(with content: UIViewController) -> Self
}

extension UINavigationController: UIViewControllerContainer {
    static func container(with content: UIViewController) -> Self {
        return self.init(rootViewController: content)
    }
}

protocol UIViewControllerDoubleContainer where Self: UIViewController {
    static func container(primary: UIViewController, secondary: UIViewController) -> Self
}

func instantiate<U: UIViewControllerDoubleContainer, P: UIViewController, S: UIViewController>(primary: ViewController<P>, secondary: ViewController<S>, in container: U.Type, setup: ((P, S) -> Void)? = nil) -> U {
    let primaryVC = primary.instantiate()
    let secondaryVC = secondary.instantiate()
    
    let inContainer = U.container(primary: primaryVC, secondary: secondaryVC)
    setup?(primaryVC, secondaryVC)
    
    return inContainer
}
