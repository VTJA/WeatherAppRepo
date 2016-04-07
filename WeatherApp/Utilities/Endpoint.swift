//
//  DataParser.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/11/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import Foundation
import AlamofireObjectMapper

let WeatherAPIKey = "867a6d0c3d80f5bb68392878262304f6"

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

protocol Endpoint {
    var baseURL: NSURL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var keypath : String { get }
}

enum WeatherEndpoint {
    case Search
    case Weather
    case ForecastByHours
    case ForecastByDays
}

enum PhotoEndpoint {
    case Photos
}

extension WeatherEndpoint : Endpoint {
    var baseURL: NSURL { return NSURL(string: "http://api.openweathermap.org/data/2.5")! }
    
    var path : String {
        switch self {
        case .Weather :
            return "/weather"
        case .Search :
            return "/find"
        case .ForecastByHours :
            return "/forecast"
        case .ForecastByDays :
            return "/forecast/daily"
        }
    }
    
    var method : HTTPMethod { return .GET }
    
    var keypath: String { return "list" }
}

