//
//  RequestDispatcher.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/17/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//
import Alamofire

final class RequestDispatcher  {
    
    static let sharedInstance = RequestDispatcher()
    
    internal var manager: Manager
    internal var reachibilityManager : NetworkReachabilityManager
    
    init(manager: Manager = Manager.sharedInstance) {
        self.manager = manager
        reachibilityManager = NetworkReachabilityManager(host: "http://openweathermap.org/api")!
        reachibilityManager.listener = {[unowned self] status  in
            
            self.reachibilityDidChange(status)
        }
    }
    
    func performRequest(endpoint: MyEndpoint, parameters: [String: AnyObject]? = nil, responseCallback: ([Forecast]?, NSError?)-> Void) {
        let URL = endpoint.baseURL.URLByAppendingPathComponent(endpoint.path)
        let method = endpoint.method.toAlamofireMethod()
        
        manager.request(method, URL , parameters: parameters, encoding: .URLEncodedInURL)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseArray(keyPath) { (response:Alamofire.Response<[Forecast], NSError>) in
                responseCallback(response.result.value, response.result.error)
        }
    }
    
    func reachibilityDidChange(status : NetworkReachabilityManager.NetworkReachabilityStatus) {
        print("\(status)")
    }
}

extension HTTPMethod {
    
    func toAlamofireMethod() -> Alamofire.Method {
        switch self {
        case .GET:
            return Method.GET
            
        case .POST:
            return Method.POST
            
        case .PUT:
            return Method.PUT
            
        case .DELETE:
            return Method.DELETE
        }
    }
}

