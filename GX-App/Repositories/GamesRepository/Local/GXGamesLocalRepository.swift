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
    
    private let storageContext: GXStorageContext
    
    init(storageContext: GXStorageContext) {
        self.storageContext = storageContext
    }
    
    // MARK: REPOSITORY
    
    func fetchGameList(query: String?, completion: @escaping (Result<[GXGameEntity], GXGameServiceError>) -> Void) {
        if let query = query, query.count > 0 {
            completion(.success([]))
        }
        
        storageContext.fetch(GXGameEntity.self, predicate: nil, sorted: nil) { (entities) in
            completion(.success(entities))
        }
    }
    
    func fetchGameDetail(gameId: Int, completion: @escaping (Result<GXGameDetailEntity?, GXGameServiceError>) -> Void) {
        let predicate = NSPredicate(format: "id = \(gameId)")
        
        storageContext.fetch(GXGameDetailEntity.self, predicate: predicate, sorted: nil) { (entities) in
            completion(.success(entities.first))
        }
    }
    
}
