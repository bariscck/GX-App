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
    
    public var hasNextPageNotifier: ((Bool) -> Void)?
    
    private var nextPageURL: URL? {
        didSet {
            hasNextPageNotifier?(nextPageURL != nil)
        }
    }
    
    // MARK: REPOSITORY
    
    func fetchGameList(query: String?, completion: @escaping (Result<[GXGameEntity], GXGameServiceError>) -> Void) {
        networkAdapter.request(.games(query: query, nextURL: nextPageURL)) { [weak self] (result: Result<GXGameListResponse, Error>) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                strongSelf.nextPageURL = response.next
                let entities: [GXGameEntity] = response.results.map(GXGameEntity.init(gameResponse:))
                completion(.success(entities))
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
