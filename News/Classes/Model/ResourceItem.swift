//
//  ResourceItem.swift
//  News
//
//  Created by 1 on 08.01.2021.
//

import Foundation

class ResourceItem: NSObject, NSCoding {
    var url: URL?
    var hashId: Int {
        get {
            return url?.absoluteString.hash ?? 0
        }
    }
    var isActive: Bool = false
    
    init(url: String) {
        self.url = URL.init(string: url)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(url: "")
        self.url = aDecoder.decodeObject(forKey: "url") as? URL
        self.isActive = aDecoder.decodeBool(forKey: "isactive")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(url, forKey: "url")
        aCoder.encode(isActive, forKey: "isactive")
    }
}
