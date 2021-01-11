//
//  AppError.swift
//  iOS-Platform
//
//  Created by Andrey Chernyshev on 24.10.16.
//  Copyright © 2016 simbirsoft. All rights reserved.
//

import UIKit

@objcMembers class RequestResultError: NSObject, Entity {
    var result: String?
    var errorCodeTitle: String?
    var errorMessage: String?
    var resultCode: NSNumber?
    
    var isSuccess: Bool? {
        guard let result = self.result else { return (resultCode == nil ? nil : resultCode == 200) }
        
        return result != "False"
    }
    
    var errorCode: Int? {
        guard let code = self.resultCode else { return nil }
        
        return Int(truncating: code)
    }
    
    convenience init(result: String, errorMessage: String, resultCode: NSNumber, errorCodeTitle: String) {
        self.init()
        
        self.result = result
        self.errorMessage = errorMessage
        self.resultCode = resultCode
        self.errorCodeTitle = errorCodeTitle
    }
    
    override func replaceSelector(selector: String) -> String {
        switch selector {
        case "Success":
            return "result"
        case "ErrCode":
            return "errorMessage"
        case "message", "description":
            return "errorMessage"
        case "statusCode":
            return "resultCode"
        case "errorCode":
            return "errorCodeTitle"
        default:
            return selector
        }
    }
}

enum AppError : String, Error {
    case Unknown = "Unknown error"
    
    case NetworkProblem = "Network problem"
    case IntegrateError = "Integrate certificate error"
    case DataMissing = "Data missing"
    
    case RealmInitializeProblem = "Realm initialize problem"
    case RealmWriteProblem = "Realm write problem"
    
    case DefaultLocaleEmpty = "Default locale empty "
    case ServerLocaleInternal = "Server internal error (defLocaleEmpty)"
    case ServerInternal = "Server internal error"
    case Unauthorization = "Authorization required"
    case NotFound = "Data not found"
    case BadRequest = "Bad request"
    
    case VKAuthProblem = "VK authorization failed"
    case FacebookAuthProblem = "Facebook authorization failed"
    case OKAuthProblem = "OK authorization failed"
    case CancelledByUser = "Cancelled by user"
    
    case VKGetFriendsProblem = "VK get friends failed"
    case FacebookGetFriendsProblem = "Facebook get friends failed"
    case OKGetFriendsProblem = "OK get friends failed"
    
    case PushProblem = "Push token not receive"
    case UserDeleted = "User deleted"
    case IncorrectPassword = "Incorrect password"
    
    case EmailInUse = "Email already in use!"
    case LoginInUse = "Login already in use"
    case PhoneInUse = "Phone already in use"
    
    case EmailOrPhoneNotFound = "Email or phone not found"
    
    case LimitExhaustedError = "No certificates"
    case NoCertificateError = "NoCertificateError"
    case CertificateCountryError = "CertificateCountryError"
    case OverdueCertificateError = "OverdueCertificateError"
    case SpentCertificateError = "SpentCertificateError"
    case DeletedCertificateError = "DeletedCertificateError"
    case CertificateOwnerAlready = "Certificate is already been this user"
    
    case CodeIsExpiredOrInvalid = "Code is expired or invalid!"
    case SmsCodeIsInvalid = "Sms code is invalid!"
    
    case PaymentError = "Payment Error"
    case InvalidToken = "Invalid token"
    case CardAlreadyAdded = "Card already added"
    case CantAddCard = "Cant add card"
    case TransactionError = "Transaction error"
    case NotSupportedCardType = "This type of card is not supported"
    case WrongCardData = "5006"
    case CardExpired = "5054"
    case WrongCVV = "5082"
    case InsufficientFunds = "InsufficientFunds"
    //Coupon Activated errors
    case CouponAlreadyUsed = "already_used"
    case CouponNotFound = "not_found"
    case CouponIncorrect = "incorrect"
    case CouponExpired = "timeout"
    case CouponSignin = "signin"
    case CouponParentExpired = "parent_link_timeout"    
    
    init?(code paymentCode: String) {
        if let _ = [ "5001", "5005", "5012", "5030", "5031",
          "5034", "5041", "5043", "5051", "5057",
          "5065", "5091", "5092", "5096", "5204",
          "5206", "5207", "5300" ].first(where: { $0 == paymentCode }) {
            self = .TransactionError
            return
        }
        if "5013" == paymentCode {
            self = .PaymentError
            return
        }
        return nil
    }
    
    static func parseCouponError(text: String) -> AppError? {
        switch text {
        case AppError.CouponNotFound.rawValue:
            return AppError.CouponNotFound
        case AppError.CouponAlreadyUsed.rawValue:
            return AppError.CouponAlreadyUsed
        case AppError.CouponIncorrect.rawValue:
            return AppError.CouponIncorrect
        case AppError.CouponExpired.rawValue:
            return AppError.CouponExpired
        case AppError.CouponSignin.rawValue:
            return AppError.CouponSignin
        default:
            return nil
        }
    }
}

extension Error {
    var errorMessage: String {
        guard let appError = self as? AppError else {
            return self.localizedDescription
        }
        return appError.rawValue
    }
}
