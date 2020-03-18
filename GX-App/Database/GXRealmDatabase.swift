//
//  GXRealmDatabase.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 18.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation
import RealmSwift

final class GXRealmDatabase: GXLocalDatabaseType {
    
    private let realm = try! Realm()
    
    typealias ModelType = Object
    typealias IdentifierType = Int
    
    func object(type: Object.Type, primaryKey: Int) -> Object? {
        return realm.object(ofType: type.self, forPrimaryKey: primaryKey)
    }
    
    func objects(type: Object.Type) -> [Object]? {
        return realm.objects(type.self).map { $0 }
    }
    
    func save(model: Object, update: Bool) {
        try! realm.write({
            if update {
                realm.add(model, update: .modified)
            } else {
                realm.add(model)
            }
        })
    }
    
    func save(models: [Object], update: Bool) {
        try! realm.write({
            if update {
                realm.add(models, update: .modified)
            } else {
                realm.add(models)
            }
        })
    }
    
    func delete(model: Object) {
        try! realm.write({
            realm.delete(model)
        })
    }
    
}
