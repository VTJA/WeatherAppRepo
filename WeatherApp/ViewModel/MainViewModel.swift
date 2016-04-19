//
//  ViewModel.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 4/15/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//
import Foundation
import UIKit

class ViewModel {
    
    var cities = [City]()
    
    func refresh() -> () {
        CachingManager.sharedInstance.updateCacheIfNeed {[weak self] (cities) in
            if let strongSelf = self {
                strongSelf.cities = cities
            }
        }
    }
    
    func getForecastsForCity(city: City) -> [Forecast] {
        return city.forecasts.map{$0}
    }
    
    func titleTextForCity(index: Int) -> String {
        let city = cities[index]
        if let tempStr = city.forecasts[0].temp?.day {
            return "\(city.name) \(tempStr)\u{00B0} C"
        } else {
            return city.name
        }
    }
    
    func forecastCellText(forecast: Forecast?) -> String {
        if let forecast = forecast {
            let date = forecast.dt
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEEE, d MMMM"
            let dateOfForecast = NSDate(timeIntervalSince1970: date)
            let forecastDateString = formatter.stringFromDate(dateOfForecast)
            let temperatureString = String(NSString(format: "%.0f",(forecast.temp?.day)!))
            return  temperatureString + "\u{00B0} C " + forecastDateString
        } else {
            return ""
        }
    }
    
    func imageForForecast(forecast: Forecast, completion: (image: UIImage)->()) {
        let imageName = forecast.weather?.icon
        let url = forecast.weather?.iconURL
        CachingManager.sharedInstance.image(imageName!,
                                            format:"png",
                                            url:url!,
                                            withCompletion: { (image) in
                                                completion(image: image)
        })
    }
    
    func configureCollectionView(collectionView : UICollectionView) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        collectionView.collectionViewLayout = layout
    }
    
}