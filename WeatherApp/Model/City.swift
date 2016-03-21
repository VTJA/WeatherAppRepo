//
//  City.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/18/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//
import ObjectMapper
import RealmSwift

class City: Object, Mappable {
    
    dynamic var id: Int = 0
    
    var coord: List<Coord> = List<Coord>()
    
    dynamic var country: String = ""
    
    dynamic var name: String = ""
    
    dynamic var population: Int = 0
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        coord <- map["coord"]
        country <- map["country"]
        name <- map["name"]
        population <- map["population"]
    }
}