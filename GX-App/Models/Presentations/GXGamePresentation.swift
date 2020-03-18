//
//  GXGamePresentation.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation

final class GXGamePresentation {
    
    // MARK: INITIALIZERS
    
    private let entity: GXGameEntity
    
    init(entity: GXGameEntity) {
        self.entity = entity
    }
    
    // MARK: PRESENTATION
    
    var id: Int { entity.id }
    var title: String { entity.name }
    var coverImageURL: URL? { URL(string: entity.backgroundImage) }
    var metacriticText: String? {
        if let metacritic = entity.metacritic.value {
            return "\(metacritic)"
        }
        return nil
    }
    var genresText: String {
         "" //game.genres.map { $0.name }.joined(separator: ", ")
    }
    var description: String? { entity.descriptionTextRaw }
    var redditURL: URL? { URL(string: entity.reddit ?? "") }
    var websiteURL: URL? { URL(string: entity.website ?? "") }
    
    private(set) var isViewedBefore: Bool = false
 
    func setViewed() { 
        isViewedBefore = true
    }
    
}
