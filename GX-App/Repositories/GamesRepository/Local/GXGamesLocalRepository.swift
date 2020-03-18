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
        var predicate: NSPredicate?
        
        if let query = query, query.count > 3 {
            let lowercasedQuery = query.lowercased()
            predicate = NSPredicate(format: "name CONTAINS[cd]", lowercasedQuery)
        }
        
        storageContext.fetch(GXGameEntity.self, predicate: predicate, sorted: nil) { (entities) in
            completion(.success(entities))
        }
    }
    
    func fetchGameDetail(gameId: Int, completion: @escaping (Result<GXGameEntity?, GXGameServiceError>) -> Void) {
        let predicate = NSPredicate(format: "id = \(gameId)")
        
        storageContext.fetch(GXGameEntity.self, predicate: predicate, sorted: nil) { (entities) in
            completion(.success(entities.first))
        }
    }
    
}
