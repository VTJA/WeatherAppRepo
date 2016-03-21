//
//  Sys.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/21/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import ObjectMapper
import RealmSwift

final class Sys : Object, Mappable {
    
    dynamic var country = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        country <- map["country"]
    }
}
