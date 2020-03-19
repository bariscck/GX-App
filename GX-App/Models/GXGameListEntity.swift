//
//  GXGameListEntity.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 19.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation
import RealmSwift

final class GXGameListEntity: Object {
    
    @objc dynamic private(set) var pk: String = ""
    @objc dynamic private var _typeRawValue: String = ""
    @objc dynamic private var _next: String? = nil
    let games = List<GXGameEntity>()
    
    var type: ListType {
        return ListType(rawValue: _typeRawValue) ?? .list
    }
    
    var nextURL: URL? {
        guard let next = _next else { return nil }
        return URL(string: next)
    }
    
    override class func primaryKey() -> String? {
        return "pk"
    }
    
    convenience init(gameListResponse: GXGameListResponse, type: ListType) {
        self.init()
        pk = GXGameListEntity.pk(for: type)
        _typeRawValue = type.rawValue
        update(with: gameListResponse)
    }
    
    convenience init(type: ListType, games: [GXGameEntity]) {
        self.init()
        self._typeRawValue = type.rawValue
        self.games.append(objectsIn: games)
    }
    
}

extension GXGameListEntity {
    func update(with gameListResponse: GXGameListResponse) {
        let gameEntities = gameListResponse.results?.compactMap(GXGameEntity.init(gameResponse:)) ?? []
        games.append(objectsIn: gameEntities)
        _next = gameListResponse.next?.absoluteString
    }
}

extension GXGameListEntity {
    enum ListType: String {
        case list = "LIST"
        case favourite = "FAVOURITE"
        case viewed = "VIEWED"
    }
    
    static func pk(for type: ListType) -> String {
        return type.rawValue
    }
}
