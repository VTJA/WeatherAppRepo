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
    
    private var downloadQueue = NSOperationQueue()
    
    private var imageBook = [String:NSData]()
    
    private var fileManager = FileManager()
    
    let queue = TaskQueue()
    
    /**
     Check if a forecast date has expired (A forecast Date has expired if a day has passed since it's
     timestamp date)
     
     - parameter forecast: a forecast from database
     
     - returns: true if difference between current date forecast date exceeds seconds per day else fail
     
     */
    
    internal func validateForecast(forecast: Forecast) -> Bool {
        return NSDate().timeIntervalSince1970 - forecast.dt > CachingManager.secPerDay ? false : true
    }
    
    /**
     Check the latest forecast for a city. If it's missing or it's date has expired
     call download forecasts
     
     - parameter city: a city stored in data base
     
     - parameter completion: completion callback
     
     */
    
    func loadForecasts(city:City, withCompletion completion: (result: [Forecast]?, error: NSError?)->()) {
        
        let cityForecasts = city.forecasts.map {$0}
        let latestForecast = city.forecasts.sorted("dt", ascending: true)
        
        if let forecast = latestForecast.first {
            if validateForecast(forecast) {
                print("forecasts for \(city.name) are valid")
                completion(result:cityForecasts, error: nil)
            } else {
                downloadForecasts(city, withCompletion: completion)
                print("forecasts for \(city.name) have invalid date.Refreshing...")
            }
        } else {
            downloadForecasts(city, withCompletion: completion)
            print("forecasts for \(city.name) missing.Downloading forecasts...")
        }
    }
    
    /**
     Schedule the downloading of forecasts in a task queue to send requests in a serial manner
     
     - parameter city: a city stored in data base
     
     - parameter completion: completion callback
     
     */
    
    func updateCacheIfNeed(withCompletion:(cities: [City])->()) {
        if queue.tasks.count == 0 {
            let repo = GenericRepository<QueryImpl, City>()
            let cities = repo.readObjects(City)
            
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
                      "appid": WeatherAPIKey,
                      "units": "metric",
                      "cnt" : "10",
                      "mode": "json"]
        
        RequestDispatcher.sharedInstance.performRequest(WeatherEndpoint.ForecastByDays, parameters: params) { (forecasts: [Forecast]?, error: NSError?) in
            if let error = error {
                print("error: \(error.description)")
                completion(result: nil, error: error)
            } else {
                if let forecasts = forecasts {
                    let repo = GenericRepository<QueryImpl, City>()
                    repo.updateValue(forecasts, forKeypath: "forecasts", forObject: city)
                }
                completion(result: forecasts, error: nil)
            }
        }
    }
    
    func image(name: String, format: String, url: NSURL, withCompletion completion: (image: UIImage)->()) {
        // if key exist >> return image at key
        if let image = fileManager.readData(name, format: format) {
            completion(image: image)
            print("image \(name) already cached")
        } else {
            downloadImage(url, completion: { [weak self] (imageData) in
                self!.fileManager.writeData(imageData!, filename: name, format: format)
                let image = UIImage(data: imageData!)
                completion(image: image!)
                })
        }
        //        else >> download and call completions?>>
    }
    
    func downloadImage(URL: NSURL , completion: (imageData: NSData?)->()) {
        
        let imageDownloader = ImageDownloader(url: URL)
        imageDownloader.completionBlock = {
            dispatch_async(dispatch_get_main_queue(), {
                completion(imageData: imageDownloader.imageData)
            })
        }
        downloadQueue.addOperation(imageDownloader)
    }
    
    func getCityPhotos(city: City, withCompletion completion: (photo: FlickrPhoto) -> ()) {
        let params = ["method":"flickr.photos.search",
                      "api_key":"b4988504fe7318e5d2d27672a50927b2",
                      "lat":String(city.coord!.lat),
                      "lon":String(city.coord!.lon),
                      "format":"json",
                      "in_gallery":"1",
                      "privacy_filter":"1",
                      "accuracy":"11",
                      "group_id":"projectweather",
                      "nojsoncallback":"1"]
        
        RequestDispatcher.sharedInstance.performRequest(PhotoEndpoint.Photos, parameters: params) { (results: [FlickrPhoto]?, error : NSError?) in
            if let results = results {
                let cityPhoto = results[7]
                print("the url for \(city.name) is \(city.photo?.photoUrl)")
                completion(photo: cityPhoto)
            } else {
                print("error downlaoding city photos \(error?.description)")
            }
        }
    }
}