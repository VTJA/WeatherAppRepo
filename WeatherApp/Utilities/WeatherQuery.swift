//
//  WeatherQuery.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 4/20/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

struct WeatherQuery {
    var text: String? = ""
    let appId: String? = "867a6d0c3d80f5bb68392878262304f6"
    let units: String? = "metric"
    let type: String? = "like"
    let mode: String? = "json"
    
    init(searchText : String) {
        self.text = searchText
    }
}
