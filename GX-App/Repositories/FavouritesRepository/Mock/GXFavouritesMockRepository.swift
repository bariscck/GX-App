//
//  GXFavouritesMockRepository.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 19.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation

final class GXFavouritesMockRepository: GXFavouritesRepositoryType {
    
    // MARK: PROPERTIES
    
    private var favourites: [GXGameEntity] = []
    
    // MARK: REPOSITORY
    
    func checkIsFavourited(id: Int, completion: @escaping (Bool) -> Void) {
        let result = favourites.contains(where: { $0.id == id })
        completion(result)
    }
    
    func fetchAllFavourites(completion: @escaping (Result<[GXGameEntity], Error>) -> Void) {
        completion(.success(favourites))
    }
    
    func addFavourite(game: GXGameEntity, completion: @escaping () -> Void) {
        favourites.append(game)
        completion()
    }
    
    func removeFavourite(game: GXGameEntity, completion: @escaping () -> Void) {
        guard let removableIndex = favourites.firstIndex(where: { $0.id == game.id }) else {
            return
        }
        favourites.remove(at: removableIndex)
        completion()
    }
    
}
