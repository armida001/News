//
//  ViewValidator.swift
//  iOS-Platform
//
//  Created by Andrey Chernyshev on 27.11.16.
//  Copyright © 2016 simbirsoft. All rights reserved.
//

import UIKit
import RxSwift

protocol ViewValidator : class {
    func check() -> Observable<(view: UIView, result: ValidationResult)>
}
