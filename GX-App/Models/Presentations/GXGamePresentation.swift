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
    
}
