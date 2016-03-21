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
    
    dynamic var clouds: Int = 0
    
    dynamic var humidity: Int = 0
    
    dynamic var main : Main?
    
    dynamic var dt: Int = 0
    
    dynamic var speed: Float = 0
    
    dynamic var rain: Float = 0
    
    dynamic var temp: Temp?
    
    dynamic var pressure: Float = 0
    
    var weather: List<Weather> = List<Weather>()
    
    dynamic var deg: Int = 0
    
    dynamic var coord : Coord?
    
    var message: String = ""

    var cod: String = ""

    var count: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        clouds <- map["clouds"]
        humidity <- map["humidity"]
        main <- map["main"]
        dt <- map["dt"]
        speed <- map["speed"]
        rain <- map["rain"]
        temp <- map["temp"]
        pressure <- map["pressure"]
        weather <- map["weather"]
        deg <- map["deg"]
        message <- map["message"]
        coord <- map["coord"]
    }
}
