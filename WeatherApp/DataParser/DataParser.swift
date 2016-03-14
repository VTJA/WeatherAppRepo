//
//  DataParser.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/11/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import Foundation
import Alamofire

let requestURL = "http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=b1b15e88fa797225412429c1c50c122a"

class DataParser  {
    
    struct MyUrl {
        static var base = "http://api.openweathermap.org"
        static var version = "/data/2.5"
        static var weather = "/weather"
        static let apiKey = "b1b15e88fa797225412429c1c50c122a"
    }
    
    static func requestDataForCity(city: String) {
        Alamofire.request(.GET, requestURL+city, parameters: ["q": city, "appid": MyUrl.apiKey]).responseJSON { response -> Void in
            
            guard response.result.isSuccess else {
                print("Error while fetching tags: \(response.result.error)")
                return
            }
            
            guard let responseJSON = response.result.value as? [String: AnyObject] else {
                print("Invalid tag information received from service")
                return
            }
            responseJSON 
            print(responseJSON)
        }
    }
}
