//
//  GXGameDetailEntity.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 18.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation
import RealmSwift

final class GXGameDetailEntity: Object {
    
    @objc dynamic private(set) var id: Int = 0
    @objc dynamic private(set) var descriptionText: String?
    @objc dynamic private(set) var descriptionTextRaw: String?
    @objc dynamic private(set) var reddit: String?
    @objc dynamic private(set) var website: String?
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    var owner: GXGameEntity? {
        return realm?.object(ofType: GXGameEntity.self, forPrimaryKey: id)
    }
    
    convenience init(detailResponse: GXGameResponse) {
        self.init()
        id = detailResponse.id
        descriptionText = detailResponse.descriptionText
        descriptionTextRaw = detailResponse.descriptionTextRaw
        reddit = detailResponse.reddit
        website = detailResponse.website
    }
    
}
