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
    
    private var requests: [Cancellable] = []
    
    // MARK: MAIN
    
    func request<Model: Decodable>(_ target: API, completion: @escaping (Result<Model, Error>) -> Void) {
        let request = provider.request(target) { (result) in
            switch result {
            case .success(let response):
                do {
                    let mappedResponse = try response.map(Model.self)
                    completion(.success(mappedResponse))
                } catch {
                    completion(.failure(error))
                    print(error.localizedDescription)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        requests.append(request)
    }
    
    func cancelAllRequests() {
        requests.forEach({ $0.cancel() })
    }
    
}
