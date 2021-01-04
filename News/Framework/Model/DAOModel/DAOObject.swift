//
//  DAOObject.swift
//  iOS-Platform
//
//  Created by Andrey Chernyshev on 24.10.16.
//  Copyright © 2016 simbirsoft. All rights reserved.
//

import UIKit
import RealmSwift

class DAOObject : Object {
    @objc dynamic var timestamp = Date().timeIntervalSince1970
}
