//
//  DayForecast.swift
//
//
//  Created by Vitalie Jurjiu on 3/21/16.
//
//
import ObjectMapper
import RealmSwift

class DayForecast : Forecast {
    
    dynamic var temp: Temp?
    
    dynamic var pressure: Float = 0
    
    dynamic var humidity: Int = 0
    
    dynamic var speed : Float = 0
    
    dynamic var cloudsDay : Int = 0
    
    dynamic var deg : Int = 0
    
    override func mapping(map: Map) {
        temp <- map["temp"]
        pressure <- map["pressure"]
        humidity <- map["humidity"]
        speed <- map["speed"]
        deg <- map["deg"]
        cloudsDay <- map["clouds"]
    }
}