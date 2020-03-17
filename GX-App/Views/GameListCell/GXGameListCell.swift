//
//  GXGameListCell.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit

final class GXGameListCell: UITableViewCell {

    // MARK: VIEWS
    
    @IBOutlet private weak var coverImageView: UIImageView! {
        didSet {
            coverImageView.contentMode = .scaleAspectFill
            coverImageView.layer.cornerRadius = 6
            coverImageView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var nameLabel: UILabel! {
        didSet {
            nameLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var metacriticContainerStack: UIStackView!
    @IBOutlet private weak var metacriticPointLabel: UILabel! {
        didSet {
            metacriticPointLabel.textColor = GXTheme.redColor
        }
    }
    @IBOutlet private weak var genresLabel: UILabel! {
        didSet {
            genresLabel.textColor = GXTheme.textTertiaryColor
            genresLabel.numberOfLines = 2
            genresLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    // MARK: MAIN
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = GXTheme.backgroundColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
        nameLabel.text = nil
        metacriticContainerStack.isHidden = false
        metacriticPointLabel.text = nil
        genresLabel.text = nil
    }
    
    func setup(with presentation: GXGamePresentation) {
        coverImageView.loadRemoteImage(url: presentation.coverImageURL)
        nameLabel.text = presentation.title
        genresLabel.text = presentation.genresText
        
        if let metacriticText = presentation.metacriticText {
            metacriticPointLabel.text = metacriticText
            metacriticContainerStack.isHidden = false
        } else {
            metacriticContainerStack.isHidden = true
        }
    }
    
    func setupForDevelopment() {
        #if DEBUG
            coverImageView.loadLocalImage(name: "gtaV")
        #endif
        nameLabel.text = "Grand Theft Auto V"
        metacriticPointLabel.text = "96"
        genresLabel.text = "Action, Shooter"
    }
    
}
