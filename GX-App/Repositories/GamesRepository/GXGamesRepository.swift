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
    func fetchGameList(query: String?, completion: @escaping (Result<GXGameListEntity?, GXGameServiceError>) -> Void)
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
    private var isRemoteFirstResponse: Bool = true
    
    // MARK: REPOSITORY
    
    func fetchGameList(query: String?, completion: @escaping (Result<GXGameListEntity?, GXGameServiceError>) -> Void) {
        
        if let query = query {
            // Fetching from remote
            remoteRepository.fetchGameList(query: query, completion: completion)
        } else {
            // Fetching from local
            localRepository.fetchGameList(query: query) { [weak self] (localResult) in
                guard let strongSelf = self else { return }
                // Displaying local results if remote doesnt have next page
                if strongSelf.remoteHasNextPage == false {
                    completion(localResult)
                }
                // Fetching from remote
                strongSelf.remoteRepository.fetchGameList(query: query, completion: { (remoteResult) in
                    // Check its first response from remote and response result is success
                    // Save only first response results
                    if strongSelf.isRemoteFirstResponse, case .success(let remoteResponse) = remoteResult {
                        strongSelf.isRemoteFirstResponse = false
                        // Remove old local results before save new results
                        if case .success(let localResponse) = localResult {
                            if let localResponse = localResponse {
                                try! strongSelf.storageContext.delete(localResponse)
                            }
                        }
                        // Save results if result is successful
                        if let remoteResponse = remoteResponse {
                            try! strongSelf.storageContext.save(remoteResponse, update: true)
                        }
                    }
                    // Displaying updated data
                    completion(remoteResult)
                })
            }
        }
    }
    
    func fetchGameDetail(gameId: Int, completion: @escaping (Result<GXGameDetailEntity?, GXGameServiceError>) -> Void) {
        // Fetching from local
        localRepository.fetchGameDetail(gameId: gameId) { [weak self] (result) in
            guard let strongSelf = self else { return }
            // Displaying local result
            completion(result)
            // Fetching from remote
            strongSelf.remoteRepository.fetchGameDetail(gameId: gameId, completion: { (result) in
                // Updating local result if success and result is not empty
                if case .success(let response) = result {
                    if let response = response {
                        try! strongSelf.storageContext.save(response, update: true)
                    }
                }
                // Displaying updated data
                completion(result)
            })
        }
    }
    
}
