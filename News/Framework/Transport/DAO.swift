//
//  DAO.swift
//  iOS-Platform
//
//  Created by Andrey Chernyshev on 25.10.16.
//  Copyright © 2016 simbirsoft. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

class DAO {
    func loadData<M: RealmMapper>(mapper: M, filter: NSPredicate? = nil) -> Observable<[M.EntityType]> {
        return Observable.create {
            observer in
            
            guard let realm = try? Realm() else {
                observer.onError(AppError.RealmInitializeProblem)
                return Disposables.create()
            }
            
            var results = realm.objects(M.RealmType.self)
            if filter != nil {
                results = results.filter(filter!)
            }
            
            let objects: [M.EntityType] = results.map {
                obj -> M.EntityType in
                return mapper.fromRealm(obj)
            }
            
            observer.onNext(objects)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func saveData<M: RealmMapper>(entities: [M.EntityType], mapper: M) -> Observable<Void> {
        return Observable.create {
            observer in
            
            guard let realm = try? Realm() else {
                observer.onError(AppError.RealmInitializeProblem)
                return Disposables.create()
            }
            
            let objects = entities.map{
                return mapper.toRealm($0)
            }
            
            do {
                try realm.write{
                    realm.add(objects, update: .all)
                }
                
                observer.onNext(())
                observer.onCompleted()
            }
            catch _ {
                observer.onError(AppError.RealmWriteProblem)
            }
            
            return Disposables.create()
        }
    }
    
    func deleteData<T: Object>(type: T, filter: NSPredicate? = nil) -> Observable<Void> {
        return Observable.create {
            observer in
            
            guard let realm = try? Realm() else {
                observer.onError(AppError.RealmInitializeProblem)
                return Disposables.create()
            }
            
            do {
                try realm.write {
                    var results = realm.objects(T.self)
                    if filter != nil {
                        results = results.filter(filter!)
                    }
                    
                    realm.delete(results)
                }
                
                observer.onNext(())
                observer.onCompleted()
            }
            catch _ {
                observer.onError(AppError.RealmWriteProblem)
            }
            
            return Disposables.create()
        }
    }
}
