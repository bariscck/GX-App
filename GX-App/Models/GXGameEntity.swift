//
//  GXGame.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation
import RealmSwift

final class GXGameEntity: Object {
    
    @objc dynamic private(set) var id: Int = 0
    @objc dynamic private(set) var name: String = ""
    @objc dynamic private(set) var backgroundImage: String = ""
    let genres = List<GXGenreEntity>()
    let metacritic = RealmOptional<Int>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(gameResponse: GXGameResponse) {
        self.init()
        id = gameResponse.id
        name = gameResponse.name
        backgroundImage = gameResponse.backgroundImage
        genres.append(objectsIn: gameResponse.genres.map(GXGenreEntity.init(genre:)))
        metacritic.value = gameResponse.metacritic
    }
    
}

final class GXGenreEntity: Object {
    @objc dynamic private(set) var id: Int = 0
    @objc dynamic private(set) var name: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(genre: GXGameResponse.Genre) {
        self.init()
        id = genre.id
        name = genre.name
    }
}

//func update(with gameResponse: GXGameResponse) {
//    id = gameResponse.id
//    name = gameResponse.name
//    backgroundImage = gameResponse.backgroundImage
//
//    if let descriptionText = gameResponse.descriptionText, descriptionText.count > 0 {
//        self.descriptionText = descriptionText
//    }
//
//    if let descriptionTextRaw = gameResponse.descriptionTextRaw, descriptionTextRaw.count > 0 {
//        self.descriptionTextRaw = descriptionTextRaw
//    }
//
//    if let reddit = gameResponse.reddit {
//        self.reddit = reddit
//    }
//
//    if let website = gameResponse.website {
//        self.website = website
//    }
//
//    genres.append(objectsIn: gameResponse.genres.map(GXGenreEntity.init(genre:)))
//    metacritic.value = gameResponse.metacritic
//}
