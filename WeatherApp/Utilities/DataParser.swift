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
        return NSURL(string: "http://api.openweathermap.org/data/2.5/")!
    }
    
    public var path : String {
        switch self {
        case .Weather :
            return "weather"
            
        case .Search :
            return "find"
        }
    }
        
    public var method : HTTPMethod {
            return .GET
    }
}

func performRequest(endpoint: MyEndpoint, parameters: [String: AnyObject]? = nil) {
    let type = endpoint.method
    let URL = endpoint.baseURL.URLByAppendingPathExtension(endpoint.path)
    
    // ["q": city, "appid": Url.apiKey, "units": Units.Celsius.rawValue, "type": "like", "mode":"json"]
    Alamofire.request(.GET, URL.baseURL.URLByAppendingPathExtension(URL.path), parameters: parameters, encoding: .URLEncodedInURL).responseObject() { (response: Alamofire.Response <Response, NSError>) in
        
        print(response.result.value?.forecastsArray)
        print(response.result.error)
        
    }

    
}




//    static func requestDataForCity(city: String) {
//        
//        let URL = MyEndpoint.Search
//        
//        
//        Alamofire.request(.GET, Url.base + Url.version + Url.weather, parameters: ["q": city, "appid": Url.apiKey, "units": Units.Celsius.rawValue, "type": "like"]).responseArray() { ( response: Response<[Forecast], NSError>) -> Void in
//            print(response.result.value)
//            print(response.result.error)
//
//        }
//            responseArray<Forecast>(keyPath: "list", { (response: Response<[Forecast], NSError>) in
//            
//        }

//        Alamofire.request(.GET, Url.base + Url.version + Url.weather, parameters: ["q": city, "appid": Url.apiKey, "units": Units.Celsius.rawValue, "type": "like"]). { response -> Void in
//            
//            guard response.result.isSuccess else {
//                print("Error while fetching tags: \(response.result.error)")
//                return
//            }
//            
//            guard let responseJSON = response.result.value as? [String: AnyObject] else {
//                print("Invalid tag information received from service")
//                return
//            }
//            
//            let forecasts : Forecast = Mapper<Forecast>().map(responseJSON)!
//            
//            print("The weather in \(forecast.cityName) is \(forecast.weatherDescription) and the temperature is \(forecast.temp)")
//        }
