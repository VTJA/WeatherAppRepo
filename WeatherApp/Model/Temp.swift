//
//  Temp.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/18/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import ObjectMapper
import RealmSwift

final class Temp: Object, Mappable  {
    
    dynamic var night: Float = 0
    
    dynamic var min: Float = 0
    
    dynamic var eve: Float = 0
    
    dynamic var day: Float = 0
    
    dynamic var max: Float = 0
    
    dynamic var morn: Float = 0
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        night <- map["night"]
        min <- map["min"]
        eve <- map["eve"]
        day <- map["day"]
        max <- map["max"]
        morn <- map["morn"]
    }
    
}
