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
    
    // MARK: MAIN
    
    func fetchGameList(query: String?, completion: @escaping (Result<[GXGameEntity], GXGameServiceError>) -> Void) {
        if let query = query {
            guard query.count > 3 else {
                return completion(.failure(.queryLimitError))
            }
        }
        
        let response = Bundle.main.decode(GXGameListResponse.self, from: "gamelist-response.json")
        let entities = response.results.map(GXGameEntity.init(gameResponse:))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion(.success(entities))
        }
    }
    
    func fetchGameDetail(gameId: Int, completion: @escaping (Result<GXGameEntity?, GXGameServiceError>) -> Void) {
        let response = Bundle.main.decode(GXGameResponse.self, from: "gamedetail-response.json")
        let entity = GXGameEntity.init(gameResponse: response)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion(.success(entity))
        }
    }
    
}
