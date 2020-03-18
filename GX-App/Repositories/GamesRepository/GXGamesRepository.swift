//
//  GXGamesRepository.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 18.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation
import RealmSwift

enum GXGameServiceError: Error {
    case serverError(Error)
    case queryLimitError
    case decodableError
}

protocol GXGamesRepositoryType {
    func fetchGameList(query: String?, completion: @escaping (Result<[GXGameEntity], GXGameServiceError>) -> Void)
    func fetchGameDetail(gameId: Int, completion: @escaping (Result<GXGameDetailEntity?, GXGameServiceError>) -> Void)
}

final class GXGamesRepository: GXGamesRepositoryType {
    
    // MARK: INITIALIZERS
    
    private let remoteRepository: GXGamesRemoteRepository
    private let localRepository: GXGamesLocalRepository
    private let storageContext: GXStorageContext
    
    init(networkAdapter: GXNetworkAdapter<GameXAPI>, storageContext: GXStorageContext) {
        remoteRepository = GXGamesRemoteRepository(networkAdapter: networkAdapter)
        localRepository = GXGamesLocalRepository(storageContext: storageContext)
        self.storageContext = storageContext
        
        remoteRepository.hasNextPageNotifier = { [weak self] hasNextPage in
            guard let strongSelf = self else { return }
            strongSelf.remoteHasNextPage = hasNextPage
        }
    }
    
    // MARK: PROPERTIES
    
    private var remoteHasNextPage: Bool = false
    
    // MARK: REPOSITORY
    
    func fetchGameList(query: String?, completion: @escaping (Result<[GXGameEntity], GXGameServiceError>) -> Void) {
        // 1. Fetching from local
        localRepository.fetchGameList(query: query) { [weak self] (result) in
            guard let strongSelf = self else { return }
            // 2. Displaying local results if remote doesnt have next page
            if strongSelf.remoteHasNextPage == false {
                completion(result)
            }
            // 3. Fetching from remote
            strongSelf.remoteRepository.fetchGameList(query: query, completion: { (result) in
                // 4. Updating local results if success
                if case .success(let response) = result {
                    try! strongSelf.storageContext.save(response, update: true)
                }
                // 5. Displaying updated data
                completion(result)
            })
        }
    }
    
    func fetchGameDetail(gameId: Int, completion: @escaping (Result<GXGameDetailEntity?, GXGameServiceError>) -> Void) {
        // 1. Fetching from local
        localRepository.fetchGameDetail(gameId: gameId) { [weak self] (result) in
            guard let strongSelf = self else { return }
            // 2. Displaying local result
            completion(result)
            // 3. Fetching from remote
            strongSelf.remoteRepository.fetchGameDetail(gameId: gameId, completion: { (result) in
                // 4. Updating local result if success and result is not empty
                if case .success(let response) = result {
                    if let response = response {
                        try! strongSelf.storageContext.save(response, update: true)
                    }
                }
                // 5. Displaying updated data
                completion(result)
            })
        }
    }
    
}
