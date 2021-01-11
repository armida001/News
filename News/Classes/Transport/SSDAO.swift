//
//  SSDAO.swift
//  iOS-Platform
//
//  Created by Andrey Chernyshev on 09.11.16.
//  Copyright © 2016 simbirsoft. All rights reserved.
//

import UIKit
import RxSwift

class SSDAO : DAO {
    // MARK: load
    func loadNews() -> Observable<[NewsItem]> {
        return loadData(mapper: NewsRealmMapper())
    }
    
    // MARK: save
    func saveNews(_ news: [NewsItem]) -> Observable<Void> {
        return saveData(entities: news, mapper: NewsRealmMapper())
    }
    
    func deleteNews() -> Observable<Void> {
        return deleteData(type: RealmNews())
    }
}
