//
//  Validator.swift
//  iOS-Platform
//
//  Created by Andrey Chernyshev on 27.11.16.
//  Copyright © 2016 simbirsoft. All rights reserved.
//

import UIKit
import RxSwift

enum ValidationResult {
    case success
    case failure
}

class Validator {
    func checkout(viewValidators: [ViewValidator]) -> Observable<(view:UIView, result: ValidationResult)> {
        return Observable.create {
            [weak self] observer in
            
            guard let `self` = self else { return Disposables.create() }
            
            for vv in viewValidators {
                vv.check().subscribe(onNext: {
                    observer.onNext($0)
                }).disposed(by: self.disposeBag)
            }
            
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    private lazy var disposeBag = DisposeBag()
}
