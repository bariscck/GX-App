//
//  GXGameService.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation
import Moya

final class GXGameService: GXGameServiceType {
    
    // MARK: INITIALIZERS
    
    private let provider: MoyaProvider<GameXAPI>
    
    init(provider: MoyaProvider<GameXAPI> = .init()) {
        self.provider = provider
    }
    
    // MARK: SERVICE TYPE
    
    func fetchGameList(query: String?, nextURL: URL?, completion: @escaping (Result<GXGameListResponse, GXGameServiceError>) -> Void) {
        if let query = query {
            // Check query count, default count must be more than 3
            guard query.count > 3 else {
                return completion(.failure(GXGameServiceError.queryLimitError))
            }
        }
        request(.games(query: query, nextURL: nextURL), completion: completion)
    }
    
    func fetchGameDetail(gameId: Int, completion: @escaping (Result<GXGame, GXGameServiceError>) -> Void) {
        request(.gameDetail(id: gameId), completion: completion)
    }
    
    // MARK: HELPERS
    
    func request<T: Decodable>(_ target: GameXAPI, completion: @escaping (Result<T, GXGameServiceError>) -> Void) {
        provider.request(target) { (result) in
            switch result {
            case .success(let response):
                do {
                    let mappedResponse = try response.map(T.self)
                    completion(.success(mappedResponse))
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                completion(.failure(.serverError(error)))
            }
        }
    }
    
}
