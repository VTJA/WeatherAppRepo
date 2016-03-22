//
//  Forecast1.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/18/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import ObjectMapper
import RealmSwift

class Forecast: Object, Mappable  {
    
    dynamic var id : Int = 0
    
    dynamic var pressure: Double = 0
    
    dynamic var humidity: Double = 0
    
    dynamic var temp : Temp?
    
    dynamic var dt: Double = 0
    
    dynamic var weather : Weather?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map[""]
        dt <- map["dt"]
        weather <- map["weather.0"]
        temp <- map["temp"]
        pressure <- map["pressure"]
        humidity <- map["humidity"]
    }
}
