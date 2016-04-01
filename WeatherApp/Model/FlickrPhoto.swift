//
//  FlickrPhoto.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/31/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import ObjectMapper

class FlickrPhoto : Mappable {
    
    var id: String = ""
    var farm: Int = 0
    var secret: String = ""
    var server: String = ""
    var title: String = ""
    
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