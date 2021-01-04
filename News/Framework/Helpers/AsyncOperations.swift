//
//  AsyncOperations.swift
//  iOS-Platform
//
//  Created by Andrey Chernyshev on 13.11.16.
//  Copyright © 2016 simbirsoft. All rights reserved.
//

import UIKit

func doAfter(delayInSec seconds: Double, action: @escaping () -> Void) {
    let delayTime = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
        action()
    }
}

func fg(block: @escaping (() -> Void)) {
    DispatchQueue.main.async {
        block()
    }
}

func bg(block: @escaping (() -> Void)) {
    DispatchQueue.global(qos: .background).async {
        block()
    }
}

func doAfter(timeIntervalInSec: Double, block: @escaping (() -> Void)) {
    DispatchQueue.main.asyncAfter(deadline:.now() + timeIntervalInSec) {
        block()
    }
}
