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
    func fetchGameDetail(gameId: Int, completion: @escaping (Result<GXGameEntity?, GXGameServiceError>) -> Void)
}

final class GXGamesRepository: GXGamesRepositoryType {
    
    // MARK: INITIALIZERS
    
    private let remoteRepository: GXGamesRemoteRepository
    private let localRepository: GXGamesLocalRepository
    
    init(networkAdapter: GXNetworkAdapter<GameXAPI>) {
        remoteRepository = GXGamesRemoteRepository(networkAdapter: networkAdapter)
        localRepository = GXGamesLocalRepository()
    }
    
    // MARK: REPOSITORY
    
    func fetchGameList(query: String?, completion: @escaping (Result<[GXGameEntity], GXGameServiceError>) -> Void) {
        localRepository.fetchGameList(query: query) { [weak self] (result) in
            completion(result)
            self?.remoteRepository.fetchGameList(query: query, completion: { (result) in
                if case .success(let response) = result {
                    self?.localRepository.save(objects: response)
                }
                completion(result)
            })
        }
    }
    
    func fetchGameDetail(gameId: Int, completion: @escaping (Result<GXGameEntity?, GXGameServiceError>) -> Void) {
        localRepository.fetchGameDetail(gameId: gameId) { [weak self] (result) in
            completion(result)
            self?.remoteRepository.fetchGameDetail(gameId: gameId, completion: { (result) in
                if case .success(let response) = result {
                    if let response = response {
                        self?.localRepository.save(object: response)
                    }
                }
                completion(result)
            })
        }
    }
    
}
