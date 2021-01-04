//
//  Session.swift
//  GiftClub
//
//  Created by Stanislav Kaluzhnyi on 02/03/17.
//  Copyright © 2017 simbirsoft. All rights reserved.
//

import Foundation

@objcMembers class Session : NSObject, Entity {
    var token: Token!
//    var profile: Account!
    
    override func replaceSelector(selector: String) -> String {
        if selector == "user" {
            return "profile"
        }
        return selector
    }
    
    override func isInnerObject(selector: String, value: Any) -> NSObject? {
        switch selector {
        case "token":
            return Token.from(element: value)
        default:
            return nil
        }
    }
}
