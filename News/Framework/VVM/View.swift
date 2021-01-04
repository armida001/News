//
//  View.swift
//  iOS-Platform
//
//  Created by Andrey Chernyshev on 24.10.16.
//  Copyright © 2016 simbirsoft. All rights reserved.
//

import UIKit

import UIKit

protocol View {
    associatedtype ViewModelType : ViewModel
    func bindTo(_ viewModel: ViewModelType)
}
