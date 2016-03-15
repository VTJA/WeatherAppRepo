//
//  Response.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/15/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import Foundation
import ObjectMapper


class Response<T> : Mappable {
    
    var forecastsArray: [T]?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        forecastsArray <- map["list"]
    }
}
