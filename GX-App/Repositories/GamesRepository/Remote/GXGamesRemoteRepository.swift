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
    
    // MARK: CALLBACKS
    
    public var hasNextPageNotifier: ((Bool) -> Void)?
    
    // MARK: PROPERTIES
    
    private var isSearching: Bool = false {
        didSet {
            if oldValue != isSearching {
                _searcingNextPageURL = nil
            }
        }
    }
    
    private var _normalNextPageURL: URL? {
        didSet {
            guard isSearching == false else { return }
            hasNextPageNotifier?(_normalNextPageURL != nil)
        }
    }
    
    private var _searcingNextPageURL: URL? {
        didSet {
            guard isSearching == true else { return }
            hasNextPageNotifier?(_searcingNextPageURL != nil)
        }
    }
    
    private var nextPageURL: URL? {
        return isSearching ? _searcingNextPageURL : _normalNextPageURL
    }
    
    // MARK: REPOSITORY
    
    func fetchGameList(query: String?, completion: @escaping (Result<[GXGameEntity], GXGameServiceError>) -> Void) {
        if let query = query {
            isSearching = query.count > 0
        } else {
            isSearching = false
        }
        
        networkAdapter.request(.games(query: query, nextURL: nextPageURL)) { [weak self] (result: Result<GXGameListResponse, Error>) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                if strongSelf.isSearching {
                    strongSelf._searcingNextPageURL = response.next
                } else {
                    strongSelf._normalNextPageURL = response.next
                }
                
                guard response.results.count > 0 else {
                    return completion(.success([]))
                }
                
                let entities: [GXGameEntity] = response.results.map(GXGameEntity.init(gameResponse:))
                print(query, entities.map { $0.name })
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
