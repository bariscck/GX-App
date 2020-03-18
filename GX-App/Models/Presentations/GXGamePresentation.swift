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
    
    init(entity: GXGameEntity?) {
        id = entity?.id ?? 0
        title = entity?.name ?? ""
        coverImageURL = URL(string: entity?.backgroundImage ?? "")
        metacriticText = String(entity?.metacritic.value ?? 0)
        genresText = entity?.genres.compactMap({ $0.name }).joined(separator: ", ") ?? ""
    }
    
}

extension GXGamePresentation {
    convenience init(detailEntity: GXGameDetailEntity) {
        self.init(entity: detailEntity.owner)
        description = detailEntity.descriptionTextRaw
        redditLink = Link(type: .reddit, url: URL(string: detailEntity.reddit ?? ""))
        websiteLink = Link(type: .website, url: URL(string: detailEntity.website ?? ""))
    }
}

extension GXGamePresentation {
    func setViewed() {
        isViewedBefore = true
    }
}
