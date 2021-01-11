//
//  RealmAccount.swift
//  iOS-Platform
//
//  Created by Andrey Chernyshev on 11.11.16.
//  Copyright © 2016 simbirsoft. All rights reserved.
//

import UIKit

class RealmNews: DAOObject {
        
    @objc dynamic var resource: RealmResourceItem?
    @objc dynamic var author: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var detail: String = ""
    @objc dynamic var imageURL: URL?
    @objc dynamic var link: URL?
    @objc dynamic var date: Date = Date()
    @objc dynamic var readed: Bool = false
    @objc dynamic var opened: Bool = false
    @objc dynamic var id: Int = 0
//    {
//        get {
//            return link?.absoluteString.hashValue ?? 0
//        }
//    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override class func ignoredProperties() -> [String] {
        var ignoredProperties = super.ignoredProperties()
        ignoredProperties.append("imageURL")
        ignoredProperties.append("link")
        return ignoredProperties
    }
}
