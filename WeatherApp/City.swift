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
    
    var cityName : String?
    var currentTemperature : Float?
    var precipitation : String?
    var uvIndex : Float?
    var weatherDescription : String?
    var imageURL: String?
    var windSpeed : Float?
    var chanceOfRain : Float?
    
}
