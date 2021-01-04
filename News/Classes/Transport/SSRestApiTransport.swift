//
//  SSRestApiTransport.swift
//  iOS-Platform

import UIKit
import RxSwift
import SwiftyJSON
import Alamofire
import KissXML

struct Headers {
    private static let secret = "88bf1cd70d"
    private static let appId = "587640c995ed3c0c59b14600"
    
    
    static func `default`(_ token: String) -> [String: String] {return ["Authorization" : "Bearer \(token)"]}
}

private struct RestApiMethods {
    static func person() -> String {return "/person"}
    static func personPassword() -> String { return "/person/password" }
    static func firmware() -> String { return "/firmware" }
    static func firmwareRequest(id: Int) -> String { return "/firmware/%@/request" }
    static func recover() -> String { return "/recover" }
    static func registration() -> String { return "/registration" }
    static func referenceCarBrand() -> String { return "/reference/car-brand" }
    static func referenceCarModel() -> String { return "/reference/car-model" }
    static func referenceEcuType() -> String { return "/reference/ecu-type" }
    static func referenceMarket() -> String { return "/reference/market" }
}

class SSRestApiTransport : RestApiTransport {
    private static var apiDomain: String {
        get {
            return "https://fw.ext-system.com/api"
        }
    }
    
    func person() -> Observable<Any> {
        return callServerApi(url: SSRestApiTransport.apiDomain + RestApiMethods.person())
    }
    
    func personPassword(password: String, currentPassword: String) -> Observable<Any> {
        let url = SSRestApiTransport.apiDomain + RestApiMethods.personPassword()
        
        let request = Request.init(parameters: ["password": currentPassword as AnyObject,
                                                "newPassword" : password as AnyObject],
                                   method: .put)
        return callServerApi(url: url, request: request)
    }
    
    func firmware(author: String, carBrand: Int, carModel: Int, ecuType: Int, market: Int, name: String, software: String) -> Observable<Any> {
        let url = SSRestApiTransport.apiDomain + RestApiMethods.firmware()
        
        let request = Request.init(parameters: ["author": author as AnyObject,
                                                "carBrand" : carBrand as AnyObject,
                                                "carModel" : carModel as AnyObject,
                                                "ecuType" : ecuType as AnyObject,
                                                "market" : market as AnyObject,
                                                "name" : name as AnyObject,
                                                "software" : software as AnyObject],
                                   method: .put)
        return callServerApi(url: url, request: request)
    }
    
    func firmwareRequest(id: Int) -> Observable<Any> {
        let url = SSRestApiTransport.apiDomain + RestApiMethods.firmwareRequest(id: id)
        return callServerApi(url: url,
                             request: Request.init(method: .post))
    }
    
    func registration(parameters: [String : AnyObject]) -> Observable<Any> {
        let url = SSRestApiTransport.apiDomain + RestApiMethods.registration()
        
        return callServerApi(url: url, request: Request.init(parameters: parameters, method: .post), encoding: JSONEncoding.default)
    }
    
    func recover(login: String) -> Observable<Any> {
        let url = SSRestApiTransport.apiDomain + RestApiMethods.recover()
        
        return callServerApi(url: url, request: Request.init(parameters: ["login": login as AnyObject], method: .post))
    }
    
    func referenceCarBrand(market: Int) -> Observable<Any> {
        let url = SSRestApiTransport.apiDomain + RestApiMethods.referenceCarBrand()
        
        return callServerApi(url: url, request: Request.init(parameters: ["market": market as AnyObject],
                                                             method: .get))
    }
    
    func referenceCarModel(ecuType: Int) -> Observable<Any> {
        let url = SSRestApiTransport.apiDomain + RestApiMethods.referenceCarModel()
        
        return callServerApi(url: url, request: Request.init(parameters: ["ecuType": ecuType as AnyObject], method: .get))
    }
    
    func referenceEcuType(carBrand: Int) -> Observable<Any> {
        let url = SSRestApiTransport.apiDomain + RestApiMethods.referenceEcuType()
        
        return callServerApi(url: url, request: Request.init(parameters: ["carBrand": carBrand as AnyObject], method: .get))
    }
    
    func referenceMarket() -> Observable<Any> {
        return callServerApi(url: SSRestApiTransport.apiDomain + RestApiMethods.referenceMarket())
    }
}
