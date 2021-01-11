//
//  NSObjectExtension.swift
//

import UIKit

@objc extension NSObject {
    class func from(array: Any) -> [NSObject] {
        if let array = array as? [AnyObject] {
            return array.map { return from(element: $0) }
        }
        return []
    }
    
    class func from(element: Any) -> Self {
        let obj = self.init()
        
        if let dict = element as? Dictionary<String, AnyObject> {
            obj.parse(from: dict)
        }
        
        return obj
    }
    
    class func from(apiFactoryArray: Any) -> [NSObject] {
        if let dict = apiFactoryArray as? Dictionary<String, AnyObject> {
            if let array = dict["data"] as? [AnyObject] {
                return array.map { return from(element: $0) }
            }
        }
        return []
    }
    
    class func from(apiFactoryElement: Any) -> Self {
        let obj = self.init()
        
        if let dict = apiFactoryElement as? Dictionary<String, AnyObject> {
            if let data = dict["data"] as? Dictionary<String, AnyObject> {
                obj.parse(from: data)
            }
        }
        
        return obj
    }
    
    
    internal func isInnerObject(selector: String, value: Any) -> NSObject? {
        return nil
    }
    
    internal func replaceSelector(selector: String) -> String {
        return selector
    }
    
    private func parse(from dict: Dictionary<String, AnyObject>) {
        func set(value: Any?, selector: String) {
            if responds(to: NSSelectorFromString(selector)) {
                if value is NSNull {
                    setValue(nil, forKey: selector)
                } else {
                    setValue(value, forKey: selector)
                }
            }
        }
        
        for (key, value) in dict {
            let selector = replaceSelector(selector: key)
            
            if value is Dictionary<String, AnyObject> {
                if let innerObj = isInnerObject(selector: selector, value: value) {
                    set(value: innerObj, selector: selector)
                }
            }
            else if let array = value as? NSArray {
                var elements: [AnyObject] = []
                
                for e in array {
                    if e is String || e is NSNumber || e is Bool {
                        elements.append(e as AnyObject)
                    }
                    else {
                        if let dict = e as? Dictionary<String, AnyObject> {
                            if let innerObj = isInnerObject(selector: selector, value: dict) {
                                elements.append(innerObj)
                            }
                        }
                    }
                }
                
                set(value: elements, selector: selector)
            }
            else  {
                set(value: value, selector: selector)
            }
        }
    }
    
    private func propertyNames() -> [String] {
        return Mirror(reflecting: self).children.filter { return $0.label != nil }.map { return $0.label! }
    }
}
