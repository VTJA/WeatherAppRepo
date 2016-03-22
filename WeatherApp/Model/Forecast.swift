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
    
    var id : Int = 0
    
    dynamic var name: String = ""
    
    dynamic var coord : Coord?
    
    dynamic var main : Main?
    
    dynamic var dt: Double = 0
    
    dynamic var wind : Wind?
    
    dynamic var rain: Float = 0
    
    dynamic var sys : Sys?
    
    dynamic var clouds : Clouds?
    
    dynamic var weather : Weather?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        main <- map["main"]
        dt <- map["dt"]
        wind <- map["wind"]
        rain <- map["rain"]
        clouds <- map["clouds"]
        weather <- map["weather.0"]
        coord <- map["coord"]
    }
}
