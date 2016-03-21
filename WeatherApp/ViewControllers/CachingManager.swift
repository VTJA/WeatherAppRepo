//
//  CachingManager.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/18/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import Foundation

final class CachingManager {
    
    static let sharedInstance = CachingManager()
    
    func validateForecasts(forecast: [Forecast]) {
        
        let currentDate = NSDate()
        
        let dateStamp = Double(forecast[0].dt)
        
        let dateOfLastForecast = NSDate(timeIntervalSince1970: dateStamp)
        
        let dayComponent = NSDateComponents()
        
        dayComponent.day = 1
        
        let calendar = NSCalendar.currentCalendar()
        
        let nextDayDate = calendar.dateByAddingComponents(dayComponent, toDate: dateOfLastForecast, options: [])
        
        if currentDate.compare(nextDayDate!) != .OrderedAscending {
            print("send reuqest to refresh data")
        } else {
            print("the data is actual")
        }
    }
}