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
    
    private var searchResults = [City]()
    
    private var repo = GenericRepository<QueryImpl, City>()
    
    let searchText = Observable<String?>("")
    
    let validSearchText = Observable<Bool>(false)
    
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
                          "appid": "867a6d0c3d80f5bb68392878262304f6",
                          "units": "metric",
                          "type": "like",
                          "mode": "json"]
            
            RequestDispatcher.sharedInstance.performRequest(WeatherEndpoint.Search, parameters: params)
            {[unowned self] (result : [City]?, error : NSError?) -> Void in
                if let result = result {
                    self.filteredCities.removeAll()
                    self.filteredCities.insertContentsOf(result, atIndex: 0)
                } else {
                    print(error?.description)
                }
                //TODO: signal reload of search table view
            }
        }
        
    }
}
