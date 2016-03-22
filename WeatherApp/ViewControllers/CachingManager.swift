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
    static let secPerDay: Double = 86400
    
    /**
     Check if a forecast date has expired (A forecast Date has expired if a day has passed since it's
     timestamp date)
     
     - parameter forecast: a forecast from database
     
     - returns: true if difference between current date forecast date exceeds seconds per day else false
     
     */
    
    internal func validateForecasts(forecast: Forecast) -> Bool {
        return NSDate().timeIntervalSince1970 - forecast.dt > CachingManager.secPerDay ? false : true
    }
    
    /**
     Check forecasts in database by id, if a forecast is missing download
     
     - parameter forecast:a forecast stored in data base
     
     - returns: void
     
     */
    
    func loadForecast(forecast: Forecast, withCompletion completion: (result: Results<Forecast>?, error: NSError?)->()) {
        let predicate = NSPredicate(format: "id = %@", forecast.id)
        let forecasts = DataBaseManager.sharedInstance.realm.objects(Forecast).filter(predicate)
        let latestForecast = forecasts.sorted("dt", ascending: false)
        
        if let forecast = latestForecast.first {
            if validateForecasts(forecast) {
                completion(result: forecasts, error: nil)
            } else {
                downloadForecasts(forecast, withCompletion: completion)
            }
            
        } else {
            downloadForecasts(forecast, withCompletion: completion)
        }
    }
    
    /**
     Download Forecasts For ID
     
     - parameter forecast:forecast id of which to be downloaded
     
     -param
     
     - returns: void
     
     */
    
    private func downloadForecasts(forecast: Forecast, withCompletion completion: (result: Results<Forecast>?, error: NSError?)->()) {
        let params = ["id":String(forecast.id),
                      "appid": APIkey,
                      "units": "metric",
                      "cnt" : "4",
                      "mode": "json"]
        
        RequestDispatcher.sharedInstance.performRequest(MyEndpoint.ForecastByDays, parameters: params) { (forecasts: [Forecast]?, error: NSError?) in
            if let error = error {
                completion(result: nil, error: error)
            } else {
//                DataBaseManager.sharedInstance.store(forecast)
            }
        }
    }
}