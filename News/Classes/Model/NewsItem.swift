//
//  NewsItem.swift
//  News
//

import Foundation

class NewsItem: NSObject {
    var author: String
    var title: String
    var detail: String
    var imageURL: URL?
    var link: URL?
    var date: Date = Date()
    var resource: ResourceItem?
    var readed: Bool = false
    var opened: Bool = false
    var hashId: Int {
        get {
            return link?.absoluteString.hash ?? 0
        }
    }
    
    override init() {        
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
