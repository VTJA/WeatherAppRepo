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
    
    private var filteredCities : [City] = [City]()
    
    private var repo = GenericRepository<QueryImpl, City>()
    
    let searchText = Observable<String?>("")
    
    init() {
        searchText.value = "Bond"
        
        searchText.observeNew {
            text in
            print(text)
        }
    }
    
    
//    func performSearch() {
//        if (searchText.characters.count > 3) {
//            
//            let params = ["q":searchText,
//                          "appid": WeatherAPIKey,
//                          "units": "metric",
//                          "type": "like" ,
//                          "mode": "json"]
//            
//            RequestDispatcher.sharedInstance.performRequest(WeatherEndpoint.Search, parameters: params)
//            {[weak self] (result : [City]?, error : NSError?) -> Void in
//                if let strongSelf = self {
//                    if let filteredCities = result {
//                        strongSelf.filteredCities = filteredCities
//                    } else {
//                        print(error?.description)
//                    }
//                    //TODO:signal reload of search table view
//                }
//            }
//        }
//    }
    
}
