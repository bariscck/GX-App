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
    
    func fetchGameList(query: String?, nextURL: URL?, completion: @escaping (Result<GXGameListEntity?, GXGameServiceError>) -> Void) {
        let response = Bundle.main.decode(GXGameListResponse.self, from: "gamelist-response.json")
        var games: [GXGameResponse]?
        
        if let query = query {
            let filteredGames = response.results?.filter({
                $0.name.lowercased().contains(query.lowercased())
            })
            games = filteredGames
        } else {
            games = response.results
        }
        
        let mappedGames = games?.map(GXGameEntity.init(gameResponse:))
        let result = GXGameListEntity(type: .list, games: mappedGames ?? [])
        
        if delay > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                completion(.success(result))
            }
        } else {
            completion(.success(result))
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
