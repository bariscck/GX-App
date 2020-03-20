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
        networkAdapter.request(.games(query: query, nextURL: nextURL)) { [weak self] (result: Result<GXGameListResponse, Error>) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let response):
                let entity = GXGameListEntity(gameListResponse: response, type: .list)
                completion(.success(entity))
            case .failure(let error):
                let parsedError = strongSelf.parseError(error)
                completion(.failure(parsedError))
            }
        }
    }
    
    func fetchGameDetail(gameId: Int, completion: @escaping (Result<GXGameDetailEntity?, GXGameServiceError>) -> Void) {
        networkAdapter.request(.gameDetail(id: gameId)) { [weak self] (result: Result<GXGameResponse, Error>) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let response):
                let entity = GXGameDetailEntity.init(detailResponse: response)
                completion(.success(entity))
            case .failure(let error):
                let parsedError = strongSelf.parseError(error)
                completion(.failure(parsedError))
            }
        }
    }
    
    // MARK: HELPERS
    
    private func parseError(_ error: Error) -> GXGameServiceError {
        if error._code == 6 {
            return .connectionError
        }
        return .serverError(error)
    }
    
}
