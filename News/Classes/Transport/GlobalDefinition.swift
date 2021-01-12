//
//  GlobalDefinition.swift
//  News
//
//  Created by 1 on 03.01.2021.
//

import Foundation

class GlobalDefinition {
    static let shared = GlobalDefinition()
    var resourceItems: [ResourceItem] = [ResourceItem]()
    
    func config() {
        UserDefaults.setCustomObject(nil, forKey: UserDefaultsKeys.lastUpdate)
        if let array = (UserDefaults.getCustomObject(forKey: UserDefaultsKeys.selectedResources) as? [ResourceItem]) {
            GlobalDefinition.shared.resourceItems = array
        } else {
            //default resources
            let baseResource = ResourceItem.init(url: "http://lenta.ru/rss")
            baseResource.isActive = true
            let baseResource2 = ResourceItem.init(url: "http://www.gazeta.ru/export/rss/lenta.xml")
            GlobalDefinition.shared.resourceItems = [baseResource, baseResource2]
            UserDefaults.setCustomObject(GlobalDefinition.shared.resourceItems, forKey: UserDefaultsKeys.selectedResources)
        }
    }
}
