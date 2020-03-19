//
//  GXGameListResponse.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation

struct GXGameListResponse: Decodable {
    let count: Int?
    let next: URL?
    let previous: String?
    let results: [GXGameResponse]?
}

struct GXGameResponse: Decodable {
    
    struct Genre: Decodable {
        let id: Int
        let name: String

        enum CodingKeys: String, CodingKey {
            case id
            case name
        }
    }
    
    var id: Int
    var name: String
    var backgroundImage: String?
    var metacritic: Int?
    var genres: [Genre]
    var descriptionText: String?
    var descriptionTextRaw: String?
    var reddit: String?
    var website: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case backgroundImage = "background_image"
        case metacritic
        case genres
        case descriptionText = "description"
        case descriptionTextRaw = "description_raw"
        case reddit = "reddit_url"
        case website = "website"
    }
}
