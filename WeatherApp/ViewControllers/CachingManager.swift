//
//  CachingManager.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/18/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import Foundation
import RealmSwift

final class CachingManager {
    
    static let sharedInstance = CachingManager()
    
    /**
     Lorem ipsum dolor sit amet.
     
     - parameter bar: Consectetur adipisicing elit.
     
     - returns: Sed do eiusmod tempor.
     */
    private func validateForecasts(forecast: Forecast) -> Bool {
        
        let nextDayDate = NSDate().timeIntervalSince1970 * 1000 + 86400000
        
        if forecast.dt < nextDayDate {
            return true
        } else {
            return false
        }
    }
    
    func loadForecast(city: City, withCompletion completion: (result: Results<Forecast>?)->()) {
        
        
        let predicate = NSPredicate(format: "id = %@", city.id)
        let forecasts = DataBaseManager.sharedInstance.realm.objects(Forecast).filter(predicate)
        let latestForecast = forecasts.sorted("dt", ascending: false)
        
        if let forecast = latestForecast.first {
            if validateForecasts(forecast) {
                completion(result: forecasts)
            } else {
                downloadForecasts(city, withCompletion: completion)
            }
            
        } else {
            downloadForecasts(city, withCompletion: completion)
        }
    }
    
    private func downloadForecasts(city: City, withCompletion completion: (result: Results<Forecast>?)->()) {
        
        RequestDispatcher.sharedInstance.performRequest(MyEndpoint.ForecastByDays, parameters: params) { [unowned self] (result : [Forecast]?, error : NSError?) -> Void in
            if let result = result {
                self.daysForecasts = result
                self.collectionView.reloadSections(NSIndexSet.init(index: 0))
                print(self.daysForecasts)
            }
        }
    }
    
}