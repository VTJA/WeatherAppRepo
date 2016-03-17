//
//  DataBaseManager.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/11/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import Foundation
import RealmSwift

let realm = try! Realm()

final class DataBaseManager {
    static func storeForecasts(forecasts : [Forecast]) {
        try! realm.write {
            realm.add(forecasts)
        }
    }
}