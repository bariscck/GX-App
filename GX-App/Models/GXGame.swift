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
    let description: String?
    let descriptionRaw: String?
    let redditURL: URL?
    let websiteURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case backgroundImage = "background_image"
        case metacritic
        case genres
        case description
        case descriptionRaw = "description_raw"
        case redditURL = "reddit_url"
        case websiteURL = "website"
    }
}

extension GXGame: Hashable {
    static func == (lhs: GXGame, rhs: GXGame) -> Bool {
        return lhs.id == rhs.id
    }
}

extension GXGame.Genre: Hashable {
    static func == (lhs: GXGame.Genre, rhs: GXGame.Genre) -> Bool {
        return lhs.id == rhs.id
    }
}
