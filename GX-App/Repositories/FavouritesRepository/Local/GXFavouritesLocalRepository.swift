//
//  GXFavouritesLocalRepository.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 19.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation

final class GXFavouritesLocalRepository: GXFavouritesRepositoryType {
    
    // MARK: INITIALIZERS
    
    private let storageContext: GXStorageContext
    
    init(storageContext: GXStorageContext) {
        self.storageContext = storageContext
    }
    
    // MARK: REPOSITORY
    
    func checkIsFavourited(id: Int, completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(format: "id = \(id)")
        storageContext.fetch(GXGameEntity.self, predicate: predicate, sorted: nil) { (results) in
            completion(results.first != nil)
        }
    }
    
    func fetchAllFavourites(completion: @escaping (Result<[GXGameEntity], Error>) -> Void) {
        storageContext.fetch(GXGameEntity.self, predicate: nil, sorted: nil) { (results) in
            completion(.success(results))
        }
    }
    
    func addFavourite(game: GXGameEntity, completion: @escaping () -> Void) {
        // TODO
    }
    
    func removeFavourite(game: GXGameEntity, completion: @escaping () -> Void) {
        // TODO
    }
    
}
