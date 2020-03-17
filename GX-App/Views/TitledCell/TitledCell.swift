//
//  TitledCell.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit

final class TitledCell: UITableViewCell {
    
    // MARK: VIEWS
    
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = GXTheme.textSecondaryColor
        }
    }
    
    // MARK: MAIN
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = GXTheme.backgroundColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    func setup(with text: String, numberOfLines: Int = 1) {
        titleLabel.text = text
        titleLabel.numberOfLines = numberOfLines
    }
    
}
