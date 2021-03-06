//
//  GXRealmStorageContext.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 18.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation
import RealmSwift

extension Object: GXStorable {}

final class GXRealmStorageContext: GXStorageContext {
    var realm: Realm?
    
    required init(configuration: GXConfigurationType = .basic(url: nil)) throws {
        var rmConfig = Realm.Configuration()
        rmConfig.readOnly = true
        switch configuration {
        case .basic:
            rmConfig = Realm.Configuration.defaultConfiguration
            if let url = configuration.associated {
                rmConfig.fileURL = NSURL(string: url) as URL?
            }
        case .inMemory:
            rmConfig = Realm.Configuration()
            if let identifier = configuration.associated {
                rmConfig.inMemoryIdentifier = identifier
            } else {
                throw NSError()
            }
        }
        try self.realm = Realm(configuration: rmConfig)
        
        print("REALM FILE PATH: ", Realm.Configuration.defaultConfiguration.fileURL?.absoluteURL ?? "")
    }
    
    public func safeWrite(_ block: (() throws -> Void)) throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        
        if realm.isInWriteTransaction {
            try block()
        } else {
            try realm.write(block)
        }
    }
}

extension GXRealmStorageContext {
    
    func save(_ object: GXStorable, update: Bool) throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        
        try self.safeWrite {
            realm.add(object as! Object, update: update ? .modified : .error)
        }
    }
    
    func save(_ objects: [GXStorable], update: Bool) throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        
        try self.safeWrite {
            realm.add(objects as! [Object], update: update ? .modified : .error)
        }
    }
    
    func update(block: @escaping () -> Void) throws {
        try self.safeWrite {
            block()
        }
    }
}

extension GXRealmStorageContext {
    func delete(_ object: GXStorable) throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        
        try self.safeWrite {
            realm.delete(object as! Object)
        }
    }
    
    func deleteAll<T : GXStorable>(_ model: T.Type) throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        
        try self.safeWrite {
            let objects = realm.objects(model as! Object.Type)
            
            for object in objects {
                realm.delete(object)
            }
        }
    }
    
    func reset() throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        
        try self.safeWrite {
            realm.deleteAll()
        }
    }
}

extension GXRealmStorageContext {
    func fetch<T: GXStorable>(_ model: T.Type, predicate: NSPredicate? = nil, sorted: GXSorted? = nil, completion: (([T]) -> ())) {
        var objects = self.realm?.objects(model as! Object.Type)
        
        if let predicate = predicate {
            objects = objects?.filter(predicate)
        }
        
        if let sorted = sorted {
            objects = objects?.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
        }
        
        var accumulate: [T] = [T]()
        for object in objects! {
            accumulate.append(object as! T)
        }
        
        completion(accumulate)
    }
}
