//
//  RestApiTransport.swift
//  iOS-Platform
//
//  Created by Andrey Chernyshev on 25.10.16.
//  Copyright © 2016 simbirsoft. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
import KissXML
import SwiftyJSON

class Request: NSObject {
    var parameters: [String : AnyObject]?
    var method: HTTPMethod = .get
    
    convenience init(parameters: [String : AnyObject]? = nil, method: HTTPMethod = .get) {
        self.init()
        self.parameters = parameters
        self.method = method
    }
    
    func requestParams() -> [String : AnyObject]? {
        guard let parameters = parameters else { return nil }
        if method == .post || method == .put {
            return ["request" : parameters as AnyObject]
        }
        return parameters
    }
}

class RestApiTransport {
    func callServerApi(url: String, request: Request? = nil, headers: [String: String]? = nil, encoding: ParameterEncoding = URLEncoding.default, _ timeOut: TimeInterval = 30) -> Observable<Any> {
        return Observable.create { observer in
            let params: Parameters = request?.parameters ?? Parameters()
            var baseHeaders: [String: String] = Headers.default("")
            if let headersDic = headers {
                for hKey in headersDic.keys {
                    baseHeaders[hKey] = headersDic[hKey]
                }
            }
            
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = timeOut
            let request = manager.request(url, method: request?.method ?? .get,
                                          parameters: params,
                                          encoding: encoding,
                                          headers: baseHeaders)
            #if DEBUG
            print("request = \(request.request)")
            print("headers = \(headers)")
            print("params = \(params)")
            #endif
            request.responseJSON { response in
                #if DEBUG
                print("response = \(response)")
                #endif
                let requestString = "\(request.request?.url) \n \(params) \n"
                switch response.result {
                case .success(let json):
                    if let errorCodeMessageValue = self.errorCodeMessage(json: json, requestString: requestString, response: response) {
                        observer.onError(self.parseError(code: errorCodeMessageValue.0, message: errorCodeMessageValue.1, errorCodeTitle: errorCodeMessageValue.2))
                    } else {
                        observer.onNext(json)
                        observer.onCompleted()
                    }
                case .failure(let error):
                    guard response.response?.statusCode != 200 else {
                        observer.onNext(["Success":"True"])
                        observer.onCompleted()
                        return
                    }
                    if (error as? URLError)?.code == .notConnectedToInternet || (error as? URLError)?.code == .timedOut || (error as? URLError)?.code == .cannotConnectToHost {
                        observer.onError(AppError.NetworkProblem)
                        return
                    }
                    observer.onError(self.parseError(code: response.response?.statusCode ?? -1, message: response.data?.errorMessage))
                }
                
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func errorCodeMessage(json: Any, requestString: String, response: DataResponse<Any>) -> (Int, String?, String?)? {
        let error = RequestResultError.from(element: json)
        if let isErrorResultSuccess = error.isSuccess, let errorCode = error.errorCode, !isErrorResultSuccess {
            return (errorCode, error.errorMessage, error.errorCodeTitle)
        } else if let status = response.response?.statusCode, status != 200 {
            var resultMessage = response.data?.errorMessage
            if let message = response.data?.errorMessage, let dict = JSON.init(parseJSON: message).dictionaryObject, let msg = dict["msg"] as? String {
                resultMessage = msg
            }
            return (status, resultMessage, error.errorCodeTitle)
        }
        return nil
    }
    
    private func parseResponse(response: Any) {
        
    }
    
    private func parseError(code: Int, message: String? = nil, errorCodeTitle: String? = nil) -> Error {
        if let message = message, let error = AppError(rawValue: message) {
            return error
        }
        
        if let message = message, let error = AppError(code: message) {
            return error
        }
        
        if let errorcodetitle = errorCodeTitle, let error = AppError.parseCouponError(text: errorcodetitle) {
            return error
        }
        
        switch code {
        case 400:
            return AppError.BadRequest
        case 401, 403:
            return AppError.Unauthorization
        case 404:
            return AppError.NotFound
        case 501, 500:
            return AppError.ServerInternal
        default:
            return AppError.Unknown
        }
    }
}
