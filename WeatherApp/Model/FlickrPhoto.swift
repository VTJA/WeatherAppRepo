//
//  FlickrPhoto.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/31/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import ObjectMapper
import RealmSwift

class FlickrPhoto : Object, Mappable {
    
    var photoId: String = ""
    var farm: Int = 0
    var secret: String = ""
    var server: String = ""
    var title: String = ""
    
    var photoUrl: NSURL {
        return NSURL(string: "http://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_m.jpg")!
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        photoId <- map["photoId"]
        farm <- map["farm"]
        secret <- map["secret"]
        server <- map["server"]
        title <- map["title"]
    }
}