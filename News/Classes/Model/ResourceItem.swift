//
//  ResourceItem.swift
//  News
//

import Foundation

enum ResourceItemKeys: String {
    case url = "url"
    case isactive = "isactive"
}

class ResourceItem: NSObject, NSCoding {
    var url: URL?
    var hashId: Int = 0
//    {
//        get {
//            return url?.absoluteString.hash ?? 0
//        }
//    }
    var isActive: Bool = false
    
    init(url: String) {
        self.url = URL.init(string: url)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(url: "")
        self.url = aDecoder.decodeObject(forKey: ResourceItemKeys.url.rawValue) as? URL
        self.isActive = aDecoder.decodeBool(forKey: ResourceItemKeys.isactive.rawValue)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(url, forKey: ResourceItemKeys.url.rawValue)
        aCoder.encode(isActive, forKey: ResourceItemKeys.isactive.rawValue)
    }
}
