//
//  GXGameServiceType.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation

protocol GXGameServiceType {
    func fetchGameList(query: String?, nextURL: URL?, completion: @escaping (Result<GXGameListResponse, GXGameServiceError>) -> Void)
    func fetchGameDetail(gameId: Int, completion: @escaping (Result<GXGame, GXGameServiceError>) -> Void)
}

enum GXGameServiceError: Error {
    case serverError(Error)
    case queryLimitError
    case decodableError
}
