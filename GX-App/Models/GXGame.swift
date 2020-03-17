//
//  GXGame.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation

struct GXGame: Decodable {
    
    struct Genre: Decodable {
        let id: Int
        let name: String

        enum CodingKeys: String, CodingKey {
            case id
            case name
        }
    }
    
    let id: Int
    let name: String
    let backgroundImage: URL
    let metacritic: Int?
    let genres: [Genre]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case backgroundImage = "background_image"
        case metacritic
        case genres
    }
}
