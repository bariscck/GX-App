//
//  GXGamePresentation.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation

struct GXGamePresentation {
    
    // MARK: INITIALIZERS
    
    private let game: GXGame
    
    init(game: GXGame) {
        self.game = game
    }
    
    // MARK: PRESENTATION
    
    var id: Int {
        return game.id
    }
    
    var title: String {
        return game.name
    }
    
    var coverImageURL: URL {
        return game.backgroundImage
    }
    
    var metacriticText: String? {
        if let metacritic = game.metacritic {
            return "\(metacritic)"
        }
        return nil
    }
    
    var genresText: String {
        return game.genres.map { $0.name }.joined(separator: ", ")
    }
    
    var description: String? {
        return game.descriptionRaw
    }
    
    var isViewedBefore: Bool = false
 
    mutating func setViewed() {
        isViewedBefore = true
    }
    
}

extension GXGamePresentation: Hashable {
    static func == (lhs: GXGamePresentation, rhs: GXGamePresentation) -> Bool {
        return lhs.id == rhs.id
    }
}
