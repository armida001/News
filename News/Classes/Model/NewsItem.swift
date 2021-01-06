//
//  NewsItem.swift
//  News
//
//  Created by 1 on 03.01.2021.
//

import Foundation

class NewsItem: NSObject {
    var id: String
    var author: String
    var title: String
    var detail: String
    var imageURL: URL?
    var link: URL?
    var date: Date = Date()
    var resourceId: Int = 0
    
    override init() {
        id = ""
        title = ""
        detail = ""
        author = ""
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
