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
    
    private let context = try! Realm()
    
    func storeObject(object: StoredObject) -> Bool {
        do {
            try context.write({
                context.add(object)
            }) } catch {
                return false
        }
        return true
    }
    
    func storeObjects(object: [StoredObject]) -> Bool {
        do {
            try context.write({
                context.add(object)
            }) } catch {
                return false
        }
        return true
    }
    
    func readObjects(query: QueryType) -> [StoredObject]? {
        let objects = context.objects(StoredObject).filter(query.buildPredicate())
        return objects.count != 0 ? objects.map{$0} : nil
    }
    
    func readObjects(objectType: StoredObject.Type) -> [StoredObject] {
        return context.objects(objectType).map(){$0}
    }
}

protocol Store {
    
    associatedtype StoredObject
    
    associatedtype QueryType
    
    func storeObject(object: StoredObject) -> Bool
    
    func storeObjects(object: [StoredObject]) -> Bool
    
    func readObjects(query: QueryType) -> [StoredObject]?
    
    func readObjects(objectType: StoredObject.Type) -> [StoredObject]
}

protocol Query {
    func buildPredicate() -> NSPredicate
}

struct QueryImpl: Query {
    
    var name : String?
    
    var id : String?
    
    func buildPredicate() -> NSPredicate {
        if let id = id {
            return NSPredicate(format : "id = %@", id)
        }
        if let name = name {
            return NSPredicate(format: "name = %@",name)
        }
        return NSPredicate(value: true)
    }
}
