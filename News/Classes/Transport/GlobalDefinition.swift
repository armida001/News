//
//  GlobalDefinition.swift
//  News
//
//  Created by 1 on 03.01.2021.
//

import Foundation

class GlobalDefinition {
    static let shared = GlobalDefinition()
    var resourceItems: [ResourceItem] = [ResourceItem.init(url: "http://lenta.ru/rss"), ResourceItem.init(url: "http://www.gazeta.ru/export/rss/lenta.xml")]    
}
