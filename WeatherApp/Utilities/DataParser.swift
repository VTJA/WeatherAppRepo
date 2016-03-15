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

let requestURL = "http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=b1b15e88fa797225412429c1c50c122a"

class DataParser  {
    
    struct Url {
        static let base = "http://api.openweathermap.org"
        static let version = "/data/2.5"
        static let weather = "/weather"
        static let apiKey = "b1b15e88fa797225412429c1c50c122a"
    }
    
    enum Units : String {
        case Fahrenheit = "imperial"
        case Celsius = "metric"
    }
    
    static func requestDataForCity(city: String) {
        Alamofire.request(.GET, Url.base + Url.version + Url.weather, parameters: ["q": city, "appid": Url.apiKey, "units": Units.Celsius.rawValue]).responseJSON { response -> Void in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            guard response.result.isSuccess else {
                print("Error while fetching tags: \(response.result.error)")
                return
            }
            
            guard let responseJSON = response.result.value as? [String: AnyObject] else {
                print("Invalid tag information received from service")
                return
            }
            
//            print(responseJSON)
            
            let forecast : Forecast = Mapper<Forecast>().map(responseJSON)!
            
            print("The weather in \(forecast.cityName) is \(forecast.weatherDescription) and the temperature is \(forecast.temp)")
        }
    }
}
