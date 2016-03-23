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
    
    let queue = TaskQueue()
    
    /**
     Check if a forecast date has expired (A forecast Date has expired if a day has passed since it's
     timestamp date)
     
     - parameter forecast: a forecast from database
     
     - returns: true if difference between current date forecast date exceeds seconds per day else false
     
     */
    
    internal func validateForecast(forecast: Forecast) -> Bool {
        return NSDate().timeIntervalSince1970 - forecast.dt > CachingManager.secPerDay ? false : true
    }
    
    /**
     Check the latest forecast for a city. if it's missing or 
     
     - parameter city: a city stored in data base
     
     - parameter completion: completion callback
     
     - returns: void
     
     */
    
    func loadForecasts(city:City, withCompletion completion: (result: [Forecast]?, error: NSError?)->()) {
        
        //        let predicate = NSPredicate(format: "id = %@", city.id)
        //        let city = DataBaseManager.sharedInstance.realm.objects(City).filter(predicate)
        let cityForecasts = city.forecasts.map { $0 }
        let latestForecast = city.forecasts.sorted("dt", ascending: false)
        
        if let forecast = latestForecast.first {
            if validateForecast(forecast) {
                print("forecasts for \(city.name) are valid")
                completion(result:cityForecasts, error: nil)
            } else {
                downloadForecasts(city, withCompletion: completion)
                print("forecasts for \(city.name) have invalid date.Downloading new forecasts...")
            }
        } else {
            downloadForecasts(city, withCompletion: completion)
            print("forecasts for \(city.name) missing.Downloading forecasts...")
        }
    }
    
    func updateCacheIfNeed(withCompletion: (cities: [City])->()) {
        if queue.tasks.count == 0 {
            let realm = try! Realm()
            let cities = realm.objects(City)
            
            if !cities.isEmpty {
                for city in cities {
                    
                    queue.tasks += {result, next in
                        self.loadForecasts(city, withCompletion: { (result, error) in
                            next(nil)
                        })
                    }
                }
                queue.tasks += { result, next in
                    withCompletion(cities: cities.map{$0})
                    print(self.queue)
                    next(nil)
                }
                queue.run()
            }
        }
    }
    
    /**
     Download forecasts for a specific city
     
     - parameter city: city forecasts of which to download
     
     - parameter completion: closure in which to retrieve forecasts array in case of success
     or error in case of failure
     
     */
    
    private func downloadForecasts(city: City, withCompletion completion: (result: [Forecast]?, error: NSError?)->()) {
        let params = ["id":String(city.id),
                      "appid": APIkey,
                      "units": "metric",
                      "cnt" : "4",
                      "mode": "json"]
        
        RequestDispatcher.sharedInstance.performRequest(MyEndpoint.ForecastByDays, parameters: params) { (forecasts: [Forecast]?, error: NSError?) in
            if let error = error {
                print("error: \(error.description)")
                completion(result: nil, error: error)
            } else {
                let realm = try! Realm()
                try! realm.write({
                    city.forecasts.removeAll()
                    print(city.forecasts)
                    city.forecasts.appendContentsOf(forecasts!)
                })
                completion(result: forecasts, error: nil)
            }
        }
    }
}