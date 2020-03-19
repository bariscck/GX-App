//
//  GXViewedGamesStorage.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 19.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation

final class GXViewedGamesStorage {
    
    @UserDefaultsStorage(key: "VIEWEDGAMEIDS", defaultValue: [])
    static private var viewedGameIds: [Int]
    
    static func checkIsViewed(id: Int) -> Bool {
        return viewedGameIds.contains(id)
    }
    
    static func addViewedGame(id: Int) {
        if checkIsViewed(id: id) == false {
            viewedGameIds.append(id)
        }
    }
    
}
