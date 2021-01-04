//
//  UserDefaultsExtension.swift
//  GiftClub
//
//  Created by iOS Developer on 16/02/2019.
//  Copyright © 2019 simbirsoft. All rights reserved.
//

import Foundation

enum UserDefaultsKeys: String {
    case deviceId = "device_id"
}

extension UserDefaults {
    static func shared() -> UserDefaults {
        if let ud = UserDefaults.init(suiteName: "group.com.simbirsoft.giftclub") {            
            return ud
        }
        return UserDefaults.standard
    }

    static func value(forKey key: UserDefaultsKeys) -> Any? {
        return UserDefaults.standard.value(forKey: key.rawValue)
    }
    
    static func setValue(_ value: Any?, forKey key: UserDefaultsKeys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    static func setCustomObject(_ value: Any?, forKey key: UserDefaultsKeys) {
        if let value = value {
            let archiveredValue = NSKeyedArchiver.archivedData(withRootObject: value)
            UserDefaults.standard.set(archiveredValue, forKey: key.rawValue)
        } else {
            UserDefaults.standard.set(nil, forKey: key.rawValue)
        }
    }
    
    static func getCustomObject(forKey key: UserDefaultsKeys) -> Any? {
        if let data = UserDefaults.standard.object(forKey: key.rawValue) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: data)
        }
        return nil
    }
    
    static func object(forKey key: UserDefaultsKeys) -> Any? {
        return UserDefaults.standard.object(forKey: key.rawValue)
    }    
    
    static func integer(forKey key: UserDefaultsKeys) -> Int {
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
    
    static func bool(forKey key: UserDefaultsKeys) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }    
}
