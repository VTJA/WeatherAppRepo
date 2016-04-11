//
//  CityPhoto.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 4/11/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import ObjectMapper
import RealmSwift

class CityPhoto: Object, Mappable {
    dynamic var name: String?
    dynamic var photoreference: String?
    dynamic var url : NSURL {
        return NSURL(string:"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(photoreference)&key=\(GooglePlacesAPIKey)")!
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        photoreference <- map["photoreference"]
    }
}
