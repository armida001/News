//
//  ViewModel.swift
//  iOS-Platform
//
//  Created by Andrey Chernyshev on 24.10.16.
//  Copyright © 2016 simbirsoft. All rights reserved.
//

import UIKit

protocol ViewModel : class {}

protocol ViewModelWithDependencies: ViewModel {
    associatedtype Input
    associatedtype Dependencies
    
    init(input: Input, dependencies: Dependencies)
}
