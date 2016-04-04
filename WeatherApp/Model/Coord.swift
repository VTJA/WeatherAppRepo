//
//  Coord.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/18/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import ObjectMapper
import RealmSwift

final class Coord: Object, Mappable  {
    dynamic var lon: Float = 0
    dynamic var lat: Float = 0
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        lon <- map["lon"]
        lat <- map["lat"]
    }
}

