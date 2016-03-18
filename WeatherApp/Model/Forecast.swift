//
//  City.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/10/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//
import Foundation
import ObjectMapper
import RealmSwift

class Forecast : Object, Mappable {
    
    dynamic var cityName : String = ""
    dynamic var weatherDescription : String = ""
    dynamic var icon: String = ""
    dynamic var humidity: Float = 0
    dynamic var temp: Float = 0
    dynamic var tempMax: Float = 0
    dynamic var tempMin: Float = 0
    dynamic var id : Int = 0
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        cityName <- map["name"]
        weatherDescription <- map["weather.0.description"]
        humidity <- map["humidity"]
        temp <- map["main.temp"]
        tempMax <- map["main.temp_max"]
        tempMin <- map["main.temp_min"]
        icon <- map["weather.0.icon"]
        id <- map["id"]
    }
}
