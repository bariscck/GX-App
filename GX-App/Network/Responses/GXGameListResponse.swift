//
//  GXGameListResponse.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation

struct GXGameListResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [GXGame]
}

extension GXGameListResponse {
    var hasNextPage: Bool {
        return next != nil
    }
}
