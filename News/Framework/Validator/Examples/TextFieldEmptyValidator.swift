//
//  TextEmptyValidator.swift
//  iOS-Platform
//
//  Created by Andrey Chernyshev on 27.11.16.
//  Copyright © 2016 simbirsoft. All rights reserved.
//

import UIKit
import RxSwift

class TextFieldEmptyValidator : ViewValidator {
    var view: UITextField
    
    required init(view: UITextField) {
        self.view = view
    }
    
    func check() -> Observable<(view: UIView, result: ValidationResult)> {
        return view.text?.isEmpty == true ? Observable.just((view: view, result: .failure)) : Observable.just((view: view, result: .success))
    }
}
