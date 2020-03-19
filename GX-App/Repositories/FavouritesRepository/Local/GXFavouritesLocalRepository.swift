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
        fetchFavouriteList { (result) in
            guard case let .success(entity) = result else {
                return completion(false)
            }
            let isFavourited = entity?.games.contains(where: { $0.id == id }) ?? false
            completion(isFavourited)
        }
    }
    
    func fetchFavouriteList(completion: @escaping (Result<GXGameListEntity?, Error>) -> Void) {
        let predicate = NSPredicate(format: "pk == %@", GXGameListEntity.pk(for: .favourite))
        storageContext.fetch(GXGameListEntity.self, predicate: predicate, sorted: nil) { (results) in
            completion(.success(results.first))
        }
    }
    
    func addFavourite(game: GXGameEntity, completion: @escaping () -> Void) {
        fetchFavouriteList { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            defer {
                completion()
            }
            
            guard case let .success(entity) = result else {
                return
            }
            if let entity = entity {
                try! strongSelf.storageContext.update {
                    entity.games.append(game)
                }
            } else {
                let entity = GXGameListEntity(type: .favourite, games: [game])
                try! strongSelf.storageContext.save(entity, update: true)
            }
        }
    }
    
    func removeFavourite(game: GXGameEntity, completion: @escaping () -> Void) {
        fetchFavouriteList { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            defer {
                completion()
            }
            
            guard case let .success(entity) = result else {
                return
            }
            
            if let entity = entity {
                guard let removableIndex = entity.games.firstIndex(of: game) else {
                    return
                }
                try! strongSelf.storageContext.update {
                    entity.games.remove(at: removableIndex)
                }
            }
            
        }
    }
    
}
