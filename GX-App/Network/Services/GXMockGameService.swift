//
//  GXMockGameService.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation

final class GXMockGameService: GXGameServiceType {
 
    var delay: TimeInterval?
    
    func fetchGameList(query: String?, nextURL: URL?, completion: @escaping (Result<GXGameListResponse, GXGameServiceError>) -> Void) {
        if let query = query {
            guard query.count > 3 else {
                return completion(.failure(.queryLimitError))
            }
        }
        
        let response = Bundle.main.decode(GXGameListResponse.self, from: "gamelist-response.json")
        
        if let delay = delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                completion(.success(response))
            }
        } else {
            completion(.success(response))
        }
    }
    
    func fetchGameDetail(gameId: Int, completion: @escaping (Result<GXGame, GXGameServiceError>) -> Void) {
        let response = Bundle.main.decode(GXGame.self, from: "gamedetail-response.json")
        
        if let delay = delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                completion(.success(response))
            }
        } else {
            completion(.success(response))
        }
    }
    
}
