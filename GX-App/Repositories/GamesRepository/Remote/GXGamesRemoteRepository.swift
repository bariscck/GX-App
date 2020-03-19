//
//  GXGamesRemoteRepository.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 18.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation

final class GXGamesRemoteRepository: GXGamesRepositoryType {
    
    // MARK: INITIALIZERS
    
    private let networkAdapter: GXNetworkAdapter<GameXAPI>
    
    init(networkAdapter: GXNetworkAdapter<GameXAPI>) {
        self.networkAdapter = networkAdapter
    }
    
    // MARK: REPOSITORY
    
    func fetchGameList(query: String?, nextURL: URL?, completion: @escaping (Result<GXGameListEntity?, GXGameServiceError>) -> Void) {
        networkAdapter.request(.games(query: query, nextURL: nextURL)) { (result: Result<GXGameListResponse, Error>) in
            switch result {
            case .success(let response):
                let entity = GXGameListEntity(gameListResponse: response, type: .list)
                completion(.success(entity))
            case .failure(let error):
                completion(.failure(.serverError(error)))
            }
        }
    }
    
    func fetchGameDetail(gameId: Int, completion: @escaping (Result<GXGameDetailEntity?, GXGameServiceError>) -> Void) {
        networkAdapter.request(.gameDetail(id: gameId)) { (result: Result<GXGameResponse, Error>) in
            switch result {
            case .success(let response):
                let entity = GXGameDetailEntity.init(detailResponse: response)
                completion(.success(entity))
            case .failure(let error):
                completion(.failure(.serverError(error)))
            }
        }
    }
    
}
