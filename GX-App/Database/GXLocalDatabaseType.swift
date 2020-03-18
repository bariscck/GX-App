//
//  GXLocalDatabase.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 18.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation

protocol GXLocalDatabaseType {
    associatedtype Model
    associatedtype IdentifierType
    
    func object(type: Model.Type, primaryKey: IdentifierType) -> Model?
    func objects(type: Model.Type) -> [Model]?
    func save(model: Model, update: Bool)
    func save(models: [Model], update: Bool)
    func delete(model: Model)
}
