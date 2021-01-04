//
//  Token.swift
//  GiftClub
//
//  Created by Nikolay Churyanin on 01.02.18.
//  Copyright © 2018 simbirsoft. All rights reserved.
//

import Foundation

@objcMembers class Token: NSObject, Entity {
    var id: String?
    var token: String!
    var refreshToken: String! = ""
    
    override func replaceSelector(selector: String) -> String {
        switch selector {
        case "user_id":
            return "id"
        case "refresh_token":
            return "refreshToken"
        case "access_token":
            return "token"
        default:
            return selector
        }
    }
}
