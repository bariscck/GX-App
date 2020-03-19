//
//  GamexAPI.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation
import Moya

enum GameXAPI {
    case games(query: String?, nextURL: URL?)
    case gameDetail(id: Int)
}

extension GameXAPI: TargetType {
    var baseURL: URL {
        let defaultURL = URL(string: "https://api.rawg.io/api/games")!
        
        switch self {
        case .games(_, let nextURL):
            if let nextURL = nextURL {
                return nextURL
            } else {
                return defaultURL
            }
        default:
            return defaultURL
        }
    }
    
    var path: String {
        switch self {
        case .gameDetail(let id):
            return "/\(id)"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .games(let query, _):
            var parameters: [String: Any] = [:]
            
            if let query = query {
                parameters["search"] = query
            }
            
            return .requestParameters(parameters: parameters,
                                      encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
