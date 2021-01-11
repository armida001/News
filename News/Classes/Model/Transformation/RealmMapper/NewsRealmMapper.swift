//
//  AccountRealmMapper.swift
//  iOS-Platform
//
//  Created by Andrey Chernyshev on 11.11.16.
//  Copyright © 2016 simbirsoft. All rights reserved.
//

import UIKit

class NewsRealmMapper : RealmMapper {
    func fromRealm(_ object: RealmNews) -> NewsItem {
                
        let result = NewsItem()
        result.id = object.id
        result.author = object.author
        result.title = object.title
        result.detail = object.detail
        result.imageURL = object.imageURL
        result.link = object.link
        result.date = object.date
        result.readed = object.readed
        result.opened = object.opened
        
        if let resourceInfo = object.resource {
            result.resource = ResourceItem(url: resourceInfo.url?.absoluteString ?? "")
        }
        return result
    }
    
    func toRealm(_ entity: NewsItem) -> RealmNews {
        
        let realmNews = RealmNews()
        realmNews.id = entity.id
        realmNews.author = entity.author
        realmNews.title = entity.title
        realmNews.detail = entity.detail
        realmNews.imageURL = entity.imageURL
        realmNews.link = entity.link
        realmNews.date = entity.date
        realmNews.readed = entity.readed
        realmNews.opened = entity.opened
        
        var resourceItem: RealmResourceItem? = nil
        if let resource = entity.resource {
            resourceItem = RealmResourceItem()
            resourceItem?.url = resource.url
        }
        
        realmNews.resource = resourceItem
        
        return realmNews
    }
}
