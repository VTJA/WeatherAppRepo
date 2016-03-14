//
//  DataParser.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/11/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import Foundation
import Alamofire

let requestURL = "api.openweathermap.org/data/2.5/weather?q="

class DataParser  {
    
    static func requestDataForCity(city: String) {
        Alamofire.request(.GET, requestURL+city).responseJSON { response -> Void in
            
            guard response.result.isSuccess else {
                print("Error while fetching tags: \(response.result.error)")
                return
            }
            
            guard let responseJSON = response.result.value as? [String: AnyObject] else {
                print("Invalid tag information received from service")
                return
            }
            print(responseJSON)
        }
    }
}
