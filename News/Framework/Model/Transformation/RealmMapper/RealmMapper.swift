//
//  RealmMapper.swift
//  iOS-Platform
//
//  Created by Andrey Chernyshev on 24.10.16.
//  Copyright © 2016 simbirsoft. All rights reserved.
//

import UIKit
import RealmSwift

protocol RealmMapper : class {
    associatedtype EntityType = Entity
    associatedtype RealmType : DAOObject
    func fromRealm(_ object: RealmType) -> EntityType
    func toRealm(_ entity: EntityType) -> RealmType
}
