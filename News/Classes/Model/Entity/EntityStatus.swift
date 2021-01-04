//
//  CertificateStatus.swift
//  GiftClub
//
//  Created by mobile.SimbirSoft on 02.10.17.
//  Copyright © 2017 simbirsoft. All rights reserved.
//

import Foundation
import SwiftyJSON

@objcMembers class EntityStatus: NSObject, Entity, NSCoding {
    enum Status: String {
        case active = "active"
        case spent = "spent"
        case overdue = "overdue"
        case deleted = "deleted"
        
        func toAppError() -> AppError? {
            switch self {
            case .spent: return .SpentCertificateError
            case .overdue: return .OverdueCertificateError
            case .deleted: return .DeletedCertificateError
            default: return nil
            }
        }
    }
    
    var id: String!
    var statusName: String!
    var statusTitle: String!
    
    var status: Status {
        return Status.init(rawValue: statusName) ?? .active
    }
        
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init()
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case statusName
        case statusTitle
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: CodingKeys.id.rawValue)
        coder.encode(statusName, forKey: CodingKeys.statusName.rawValue)
        coder.encode(statusTitle, forKey: CodingKeys.statusTitle.rawValue)
    }
    
    override func replaceSelector(selector: String) -> String {
        switch selector {
        case "name_en":
            return "statusName"
        case "name":
            return "statusTitle"
        default:
            return selector
        }
    }
}
