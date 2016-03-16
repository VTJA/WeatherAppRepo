//
//  DataParser.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/11/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

public protocol Endpoint {
    var baseURL: NSURL { get }
    var path: String { get }
    var method: HTTPMethod { get }
}

public enum MyEndpoint {
    case Search
    case Weather
}

extension MyEndpoint : Endpoint {
    public var baseURL: NSURL {
        return NSURL(string: "http://api.openweathermap.org/data/2.5")!
    }
    
    public var path : String {
        switch self {
        case .Weather :
            return "/weather"
        case .Search :
            return "/find"
        }
    }
    
    public var method : HTTPMethod {
        return .GET
    }
}

final class DataParser {
    static func performRequest(endpoint: MyEndpoint, parameters: [String: AnyObject]? = nil, responseCallback: ([Forecast]?, NSError?)-> Void) {
        
        let URL = endpoint.baseURL.URLByAppendingPathComponent(endpoint.path)
        
        Alamofire.request(.GET, URL , parameters: parameters, encoding: .URLEncodedInURL).responseArray("list") { (response:Alamofire.Response<[Forecast], NSError>) in
                        responseCallback(response.result.value, response.result.error)
            
            if let forecasts = response.result.value {
                for fr in forecasts {
                    print(fr.cityName)
                    print(fr.temp)
                }
            }
        }
    }
}
