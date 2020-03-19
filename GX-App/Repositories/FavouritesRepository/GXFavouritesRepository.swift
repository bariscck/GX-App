//
//  GXFavouritesRepository.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 19.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation

protocol GXFavouritesRepositoryType {
    func checkIsFavourited(id: Int, completion: @escaping (Bool) -> Void)
    func fetchFavouriteList(completion: @escaping (Result<GXGameListEntity?, Error>) -> Void)
    func addFavourite(game: GXGameEntity, completion: @escaping () -> Void)
    func removeFavourite(game: GXGameEntity, completion: @escaping () -> Void)
}

final class GXFavouritesRepository: GXFavouritesRepositoryType {
    
    // MARK: INITIALIZERS
    
    private let localRepository: GXFavouritesLocalRepository
    
    init(storageContext: GXStorageContext) {
        localRepository = GXFavouritesLocalRepository(storageContext: storageContext)
    }
    
    // MARK: REPOSITORY
    
    func checkIsFavourited(id: Int, completion: @escaping (Bool) -> Void) {
        localRepository.checkIsFavourited(id: id, completion: completion)
    }
    
    func fetchFavouriteList(completion: @escaping (Result<GXGameListEntity?, Error>) -> Void) {
        localRepository.fetchFavouriteList(completion: completion)
    }
    
    func addFavourite(game: GXGameEntity, completion: @escaping () -> Void) {
        localRepository.addFavourite(game: game, completion: completion)
    }
    
    func removeFavourite(game: GXGameEntity, completion: @escaping () -> Void) {
        localRepository.removeFavourite(game: game, completion: completion)
    }
    
}
