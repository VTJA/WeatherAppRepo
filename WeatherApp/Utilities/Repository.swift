//
//  DataBaseManager.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/11/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import Foundation
import RealmSwift


class GenericRepository <T : Query, C : Object>: Store {
    
    typealias StoredObject = C
    
    typealias QueryType =  T
    
    private let realm = try! Realm()
    
    func storeObject(object: StoredObject) -> Bool {
        try 
        return false
    }
    
    func readObject(query: QueryType) -> StoredObject? {
        return nil
    }
    
    func storeObjects(object: [StoredObject]) -> Bool {
        return false
    }
    
    func readObjects(query: QueryType) -> [StoredObject]? {
        let objects = realm.objects(StoredObject).filter(query.buildPredicate())
        return objects.count != 0 ? objects.map{$0} : nil
    }
}

protocol Store {
    
    associatedtype StoredObject
    
    associatedtype QueryType
    
    func storeObject(object: StoredObject ) -> Bool
    
    func readObject(query: QueryType) -> StoredObject?
    
    func storeObjects(object: [StoredObject]) -> Bool
    
    func readObjects(query: QueryType) -> [StoredObject]?
}

protocol Query {
    func buildPredicate() -> NSPredicate
}

struct QueryBuilder {
    
    var name : String
    
    var id : String
}
