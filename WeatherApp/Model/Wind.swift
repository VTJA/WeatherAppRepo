//
//  Wind.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/21/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import ObjectMapper
import RealmSwift

class Wind : Object, Mappable {
    
    dynamic var speed : Float = 0
    
    dynamic var deg : Float = 0
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        speed <- map["speed"]
        deg <- map["deg"]
    }
}