//
//  RealmUserPhoto.swift
//  BrightLive
//
//  Created by Danila Matyushin on 23.01.17.
//  Copyright © 2017 simbirsoft. All rights reserved.
//

import Foundation

class RealmResourceItem: DAOObject {
    @objc dynamic var url: URL?
    @objc dynamic var id: Int = 0
//    {
//        get {
//            return url?.absoluteString.hashValue ?? 0
//        }
//    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override class func ignoredProperties() -> [String] {
        var ignoredProperties = super.ignoredProperties()
        ignoredProperties.append("url")
        return ignoredProperties
    }
}
