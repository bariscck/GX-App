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
    
    private let localDatabase: GXRealmDatabase
    
    init(localDatabase: GXRealmDatabase) {
        self.localDatabase = localDatabase
    }
    
    // MARK: REPOSITORY
    
    func fetchGameList(query: String?, completion: @escaping (Result<[GXGameEntity], GXGameServiceError>) -> Void) {
        let entities: [GXGameEntity] = (localDatabase.objects(type: GXGameEntity.self) ?? []) as [GXGameEntity]
        
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
        let entity: GXGameEntity? = localDatabase.object(type: GXGameEntity.self, primaryKey: gameId) as? GXGameEntity
        completion(.success(entity))
    }
    
}
