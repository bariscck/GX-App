//
//  GXGamePresentation.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation

final class GXGamePresentation {
    
    struct Link {
        enum LinkType {
            case reddit, website
        }
        
        let type: LinkType
        let url: URL?
    }
    
    private(set) var id: Int = 0
    private(set) var title: String = ""
    private(set) var coverImageURL: URL?
    private(set) var metacriticText: String?
    private(set) var genresText: String = ""
    private(set) var description: String?
    private(set) var redditLink: Link?
    private(set) var websiteLink: Link?
    
    private(set) var isViewedBefore: Bool = false
    
    init(entity: GXGameEntity) {
        id = entity.id
        title = entity.name
        coverImageURL = URL(string: entity.backgroundImage ?? "")
        metacriticText = String(entity.metacritic.value ?? 0)
        genresText = entity.genres.map { $0.name }.joined(separator: ", ")
    }
    
}

extension GXGamePresentation {
    convenience init?(detailEntity: GXGameDetailEntity) {
        guard let owner = detailEntity.owner else {
            return nil
        }
        self.init(entity: owner)
        description = detailEntity.descriptionTextRaw ?? "No description."
        redditLink = Link(type: .reddit, url: URL(string: detailEntity.reddit ?? ""))
        websiteLink = Link(type: .website, url: URL(string: detailEntity.website ?? ""))
    }
}

extension GXGamePresentation: Hashable {
    static func == (lhs: GXGamePresentation, rhs: GXGamePresentation) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension GXGamePresentation {
    func setViewed() {
        isViewedBefore = true
    }
}
