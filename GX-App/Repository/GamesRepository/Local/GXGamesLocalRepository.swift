//
//  GXGamesLocalRepository.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 18.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation
import RealmSwift

final class GXGamesLocalRepository: GXGamesRepositoryType {
    
    // MARK: INITIALIZERS
    
    private let realm: Realm
    
    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }
    
    // MARK: REPOSITORY
    
    func fetchGameList(query: String?, completion: @escaping (Result<[GXGameEntity], GXGameServiceError>) -> Void) {
        let entities: [GXGameEntity] = realm.objects(GXGameEntity.self).map { $0 }
        
        if let query = query, query.count > 3 {
            let lowercasedQuery = query
            let filteredEntities = entities.filter({ entity in
                let lowercasedName = entity.name.lowercased()
                return lowercasedName.contains(lowercasedQuery)
            })
            completion(.success(filteredEntities))
        }
        
        completion(.success(entities))
    }
    
    func fetchGameDetail(gameId: Int, completion: @escaping (Result<GXGameEntity?, GXGameServiceError>) -> Void) {
        let entity: GXGameEntity? = realm.object(ofType: GXGameEntity.self, forPrimaryKey: gameId)
        completion(.success(entity))
    }
    
    // MARK: REALM
    
    func save(object: Object) {
        try! realm.write({
            realm.add(object, update: .modified)
        })
    }
    
    func save(objects: [Object]) {
        try! realm.write({
            realm.add(objects, update: .modified)
        })
    }
    
}
