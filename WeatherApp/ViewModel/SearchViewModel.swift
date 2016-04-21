//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 4/19/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//
import Foundation
import Bond

class SearchViewModel {
    
    let filteredCities = ObservableArray<City>()
    
    private var repo = GenericRepository<QueryImpl, City>()
    
    let searchText = Observable<String?>("")
    
    let validSearchText = Observable<Bool>(false)
    
    let errorMessages = EventProducer<String>()
    
    init() {
        searchText
            .map {$0!.characters.count > 3}
            .bindTo(validSearchText)
        
        searchText
            .filter { $0!.characters.count > 3 }
            .throttle(0.5, queue: Queue.Main)
            .observe {
                [unowned self] text in
                self.performSearch(self.searchText.value ?? "")
        }
    }
    
    func performSearch(text: String?) -> () {
        if let text = text {
            let params = ["q": text,
                          "appid": WeatherAPIKey,
                          "units": "metric",
                          "type": "like",
                          "mode": "json"]
            
            RequestDispatcher.sharedInstance.performRequest(WeatherEndpoint.Search, parameters: params)
            {[unowned self] (result : [City]?, error : NSError?) -> Void in
                if let result = result {
                    self.filteredCities.removeAll()
                    self.filteredCities.insertContentsOf(result, atIndex: 0)
                } else {
                    self.errorMessages
                    .next("There was an API request issue of some sort.")
                }
            }
        }
    }
    
    func storeCityAtIndex(index: Int) -> Bool {
        return repo.storeObject(filteredCities[index])
    }
}
