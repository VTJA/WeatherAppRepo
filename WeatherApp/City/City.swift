//
//  City.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/10/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//
import RealmSwift
import Foundation

class City : Object {
    
    dynamic var cityName : String?
    dynamic var precipitation : String?
    dynamic var weatherDescription : String?
    dynamic  var imageURL: String?
    var currentTemperature = RealmOptional <Float>()
    var uvIndex = RealmOptional <Float>()
    var windSpeed = RealmOptional <Float>()
    var chanceOfRain = RealmOptional <Float>()
}
