//
//  GXGamesMockRepository.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 18.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation

final class GXGamesMockRepository: GXGamesRepositoryType {
    
    // MARK: INITIALIZERS
    
    private var delay: TimeInterval
    
    init(delay: TimeInterval = 1) {
        self.delay = delay
    }
    
    // MARK: REPOSITORY
    
    func fetchGameList(query: String?, completion: @escaping (Result<GXGameListEntity?, GXGameServiceError>) -> Void) {
        if let query = query {
            guard query.count > 3 else {
                return completion(.failure(.queryLimitError))
            }
        }
        
        let response = Bundle.main.decode(GXGameListResponse.self, from: "gamelist-response.json")
        let entity = GXGameListEntity(gameListResponse: response, type: .list)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion(.success(entity))
        }
    }
    
    func fetchGameDetail(gameId: Int, completion: @escaping (Result<GXGameDetailEntity?, GXGameServiceError>) -> Void) {
        let response = Bundle.main.decode(GXGameResponse.self, from: "gamedetail-response.json")
        let entity = GXGameDetailEntity(detailResponse: response)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion(.success(entity))
        }
    }
    
}
