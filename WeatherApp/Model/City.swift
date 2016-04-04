//
//  City.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/18/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//
import ObjectMapper
import RealmSwift

final class City: Object, Mappable {
    dynamic var id: Int = 0
    dynamic var coord : Coord?
    dynamic var name: String = ""
    var forecasts = List<Forecast>()
    var photo : FlickrPhoto?
    
    required convenience init?(_ map: Map) {
        self.init()

    }
    
    func mapping(map: Map) {
        id <- map["id"]
        coord <- map["coord"]
        name <- map["name"]
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
