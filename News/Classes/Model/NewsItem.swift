//
//  NewsItem.swift
//  News
//
//  Created by 1 on 03.01.2021.
//

import Foundation

class NewsItem: NSObject {
    var id: String
    var resource: String
    var title: String
    var detail: String
    var imageURL: URL?
    
    override init() {
        id = ""
        resource = ""
        title = ""
        detail = ""
    }
}

enum NewsItemLoadingError : Error {
    case networkingError(Error)
    case requestFailed(Int)
    case serverError(Int)
    case notFound
    case feedParsingError(Error)
    case missingAttribute(String)
}
