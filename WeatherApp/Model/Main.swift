//
//  Main.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/21/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import ObjectMapper
import RealmSwift

class Main: Object, Mappable {
    
    dynamic var humidity: Int = 0
    
    dynamic var temp_min: Double = 0
    
    dynamic var temp_max: Double = 0
    
    dynamic var temp: Double = 0
    
    dynamic var pressure: Double = 0
    
    dynamic var sea_level: Double = 0
    
    dynamic var grnd_level: Double = 0
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        humidity <- map["humidity"]
        temp_min <- map["temp_min"]
        temp_max <- map["temp_max"]
        temp <- map["temp"]
        pressure <- map["pressure"]
        sea_level <- map["sea_level"]
        grnd_level <- map["grnd_level"]
    }
}