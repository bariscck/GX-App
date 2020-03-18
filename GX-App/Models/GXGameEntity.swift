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
    @objc dynamic private(set) var descriptionText: String? = nil
    @objc dynamic private(set) var descriptionTextRaw: String? = nil
    @objc dynamic private(set) var reddit: String? = nil
    @objc dynamic private(set) var website: String? = nil
    let metacritic = RealmOptional<Int>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}

extension GXGameEntity {
    convenience init(gameResponse: GXGameResponse) {
        self.init()
        id = gameResponse.id
        name = gameResponse.name
        backgroundImage = gameResponse.backgroundImage
        descriptionText = gameResponse.descriptionText
        descriptionTextRaw = gameResponse.descriptionTextRaw
        reddit = gameResponse.reddit
        website = gameResponse.website
        metacritic.value = gameResponse.metacritic
    }
}
