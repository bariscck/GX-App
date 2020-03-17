//
//  GXGameHeaderView.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit

final class GXGameHeaderView: UIView {

    // MARK: VIEWS
    
    @IBOutlet private weak var coverImageView: UIImageView! {
        didSet {
            coverImageView.contentMode = .scaleAspectFill
            coverImageView.backgroundColor = .black
        }
    }

    @IBOutlet private weak var overlayImageView: UIImageView! {
        didSet {
            overlayImageView.contentMode = .scaleToFill
            overlayImageView.loadLocalImage(name: "overlay")
        }
    }
    
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = .white
            titleLabel.textAlignment = .right
            titleLabel.numberOfLines = 0
        }
    }
    
    // MARK: MAIN
    
    func setup(with presentation: GXGamePresentation) {
        coverImageView.loadRemoteImage(url: presentation.coverImageURL)
        titleLabel.text = presentation.title
    }
    
    func setupForDevelopment() {
        #if DEBUG
            coverImageView.loadLocalImage(name: "gtaV")
        #endif
        titleLabel.text = "Grand Theft Auto V"
    }
    
}
