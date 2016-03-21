//
//  Weather.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/18/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import ObjectMapper
import RealmSwift

class Weather: Object, Mappable  {
    
    dynamic var id: Int = 0
    
    dynamic var main: String = ""
    
    dynamic var icon: String = ""
    
    dynamic var descriptionWeather: String = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        main <- map["main"]
        icon <- map["icon"]
        descriptionWeather <- map["description"]
    }
}