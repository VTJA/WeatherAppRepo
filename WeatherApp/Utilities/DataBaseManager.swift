//
//  DataBaseManager.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/11/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import Foundation
import RealmSwift


final class DataBaseManager {
    
    static let sharedInstance =  DataBaseManager()
    
    func store(forecast : Forecast) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(forecast, update: true)
        }
    }
}