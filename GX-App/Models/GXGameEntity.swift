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
    @objc dynamic private(set) var backgroundImage: String?
    let genres = List<GXGenreEntity>()
    let metacritic = RealmOptional<Int>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, name: String, backgroundImage: String?,
                     genres: [GXGenreEntity], metacritic: Int?) {
        self.init()
        self.id = id
        self.name = name
        self.backgroundImage = backgroundImage
        self.genres.append(objectsIn: genres)
        self.metacritic.value = metacritic
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
    
    convenience init(id: Int, name: String) {
        self.init()
        self.id = id
        self.name = name
    }
    
    convenience init(genre: GXGameResponse.Genre) {
        self.init()
        id = genre.id
        name = genre.name
    }
    
}
