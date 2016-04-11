//
//  Request.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/18/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import ObjectMapper
import RealmSwift

final class Request: Object, Mappable {
    dynamic var cod: String?
    dynamic var city: City?
    dynamic var cnt: Int = 0
    var list : List<Forecast> = List<Forecast>()
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        cod <- map["cod"]
        city <- map["city"]
        cnt <- map["cnt"]
        list <- map["list"]
    }
}