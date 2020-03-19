//
//  GXNetworkAdapter.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 18.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation
import Moya

final class GXNetworkAdapter<API: TargetType> {
    
    // MARK: INITIALIZERS
    
    private let provider: MoyaProvider<API>
    
    init(provider: MoyaProvider<API> = .init()) {
        self.provider = provider
    }
    
    // MARK: PROPERTIES
    
    /**
     - Requests; container for all requests
     */
    private var requests: [Cancellable] = []
    
    // MARK: MAIN
    
    func request<Model: Decodable>(_ target: API, completion: @escaping (Result<Model, Error>) -> Void) {
        let request = provider.request(target) { (result) in
            switch result {
            case .success(let response):
                do {
                    // Map response to Decodable Object
                    let mappedResponse = try response.map(Model.self)
                    
                    completion(.success(mappedResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        requests.append(request)
    }
    
    /**
     - We can cancel all active requests with this method
     */
    func cancelAllRequests() {
        requests.forEach({ $0.cancel() })
    }
    
}
