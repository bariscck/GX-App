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
        }
    }

    @IBOutlet private weak var overlayImageView: UIImageView! {
        didSet {
            overlayImageView.contentMode = .scaleToFill
            overlayImageView.image = UIImage(named: "overlay")
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
    
    func setupForDevelopment() {
        #if DEBUG
            coverImageView.image = UIImage(named: "gtaV")
        #endif
        titleLabel.text = "Grand Theft Auto V"
    }
    
}
