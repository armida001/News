//
//  ResourceItem.swift
//  News
//
//  Created by 1 on 08.01.2021.
//

import Foundation

class ResourceItem: NSObject {
    var url: URL?
    var id: Int = 0
    
    init(url: String) {
        self.url = URL.init(string: url)
    }
}
