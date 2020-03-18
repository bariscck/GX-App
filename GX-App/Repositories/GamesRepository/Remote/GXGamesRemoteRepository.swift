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
    
    // MARK: PROPERTIES
    
    private var nextPageURL: URL?
    
    // MARK: REPOSITORY
    
    func fetchGameList(query: String?, completion: @escaping (Result<[GXGameEntity], GXGameServiceError>) -> Void) {
        networkAdapter.request(.games(query: query, nextURL: nextPageURL)) { [weak self] (result: Result<GXGameListResponse, Error>) in
            switch result {
            case .success(let response):
                self?.nextPageURL = response.next
                let entities: [GXGameEntity] = response.results.map(GXGameEntity.init(gameResponse:))
                completion(.success(entities))
            case .failure(let error):
                completion(.failure(.serverError(error)))
            }
        }
    }
    
    func fetchGameDetail(gameId: Int, completion: @escaping (Result<GXGameEntity?, GXGameServiceError>) -> Void) {
        networkAdapter.request(.gameDetail(id: gameId)) { (result: Result<GXGameResponse, Error>) in
            switch result {
            case .success(let response):
                let entity = GXGameEntity.init(gameResponse: response)
                completion(.success(entity))
            case .failure(let error):
                completion(.failure(.serverError(error)))
            }
        }
    }
    
}
