//
//  UserDefaultsExtension.swift
//

import Foundation

enum UserDefaultsKeys: String {
    case updateInterval = "update_interval"
    case lastUpdate = "last_update"
    case selectedResources = "selected_resources"
}

extension UserDefaults {
    static func shared() -> UserDefaults {
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
    
    static func getIntervalType() -> AutoUpdateInterval {
        if let intervalTypeConstant = UserDefaults.getCustomObject(forKey: UserDefaultsKeys.updateInterval) as? Int,
           let intervalType = AutoUpdateInterval.init(rawValue: intervalTypeConstant) {
            return intervalType
        }
        return AutoUpdateInterval.none
    }
}
