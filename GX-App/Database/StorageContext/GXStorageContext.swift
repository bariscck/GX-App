//
//  GXStorageContext.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 18.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation

/*
Dummy protocol for Entities
*/
public protocol GXStorable {
}


/* Query options */
public struct GXSorted {
    var key: String
    var ascending: Bool = true
}

protocol GXStorageContext {
    /*
     Create a new object with default values
     return an object that is conformed to the `Storable` protocol
     */
    //func create<T: GXStorable>(_ model: T.Type, completion: @escaping ((T) -> Void)) throws
    /*
     Save an object that is conformed to the `Storable` protocol
    */
    func save(_ object: GXStorable, update: Bool) throws
    /*
     Save an objects that is conformed to the `Storable` protocol
    */
    func save(_ objects: [GXStorable], update: Bool) throws
    /*
    Update an object that is conformed to the `Storable` protocol
    */
    func update(block: @escaping () -> ()) throws
    /*
    Delete an object that is conformed to the `Storable` protocol
    */
    func delete(_ object: GXStorable) throws
    /*
    Delete all objects that are conformed to the `Storable` protocol
    */
    func deleteAll<T: GXStorable>(_ model: T.Type) throws
    /*
    Return a list of objects that are conformed to the `Storable` protocol
    */
    func fetch<T: GXStorable>(_ model: T.Type, predicate: NSPredicate?, sorted: GXSorted?, completion: (([T]) -> ()))
}

/* Storage config options */
public enum GXConfigurationType {
    case basic(url: String?)
    case inMemory(identifier: String?)
    
    var associated: String? {
        get {
            switch self {
            case .basic(let url)            : return url
            case .inMemory(let identifier)  : return identifier
            }
        }
    }
}
