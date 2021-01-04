//
//  ViewBinding.swift
//  iOS-Platform
//
//  Created by Andrey Chernyshev on 24.10.16.
//  Copyright © 2016 simbirsoft. All rights reserved.
//

import UIKit
import RxCocoa

extension View where Self: UIViewController {
    func bindOnViewLoadedTo(_ viewModel: ViewModelType) {
        _ = (self as UIViewController).rx.sentMessage(#selector(viewDidLoad)).take(1).subscribe(onNext: {
            _ in
            self.bindTo(viewModel)
        })
    }
}

infix operator <~ : binding

precedencegroup binding {
    associativity: none
}

func <~<V>(view: V, viewModel: V.ViewModelType) where V: UIViewController, V: View {
    bind(view: view, viewModel: viewModel)
}

func bind<V>(view: V, viewModel: V.ViewModelType) where V: UIViewController, V: View {
    view.bindOnViewLoadedTo(viewModel)
}

extension View where Self: UIViewController, ViewModelType: ViewModelWithDependencies {
    func bind(viewModelFactory: @escaping (Self) -> ViewModelType) {
        _ = self.rx
            .methodInvoked(#selector(viewDidLoad))
            .takeUntil(self.rx.deallocating)
            .take(1)
            .subscribe(onNext: { [unowned self] _ in
                let viewModel = viewModelFactory(self)
                self.bindTo(viewModel)
            })
    }
}
