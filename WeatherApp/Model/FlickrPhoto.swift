//
//  FlickrPhoto.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/31/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import ObjectMapper
import RealmSwift

class FlickrPhoto : Mappable {
    dynamic var id: String = ""
    dynamic var farm: Int = 0
    dynamic var secret: String = ""
    dynamic var server: String = ""
    dynamic var title: String = ""
    
    var photoUrl: NSURL {
        return NSURL(string: "http://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")!
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        farm <- map["farm"]
        secret <- map["secret"]
        server <- map["server"]
        title <- map["title"]
    }
}

