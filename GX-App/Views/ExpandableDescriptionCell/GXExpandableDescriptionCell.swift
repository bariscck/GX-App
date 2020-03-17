//
//  GXExpandableDescriptionCell.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit

final class GXExpandableDescriptionCell: UITableViewCell {

    // MARK: PROPERTIES
    
    private var expandStateChangeNotifier: (() -> Void)?
    
    private var isExpanded: Bool = false {
        didSet {
            renderReadMore(for: isExpanded)
            expandStateChangeNotifier?()
        }
    }
    
    // MARK: VIEWS
    
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 0
        }
    }
    @IBOutlet private weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.setLineSpacing(4)
        }
    }
    @IBOutlet private weak var readMoreBtn: UIButton! {
        didSet {
            readMoreBtn.tintColor = GXTheme.primaryColor
        }
    }
    
    // MARK: MAIN
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = GXTheme.backgroundColor
        selectionStyle = .none
        isExpanded = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        descriptionLabel.text = nil
        isExpanded = false
    }
    
    private func renderReadMore(for expandedState: Bool) {
        if isExpanded {
            readMoreBtn.setTitle("Read Less", for: .normal)
        } else {
            readMoreBtn.setTitle("Read More", for: .normal)
        }
        
        descriptionLabel.numberOfLines = isExpanded ? 0 : 4
    }
    
    func setupForDevelopment(expandStateChangeNotifier: (() -> Void)?) {
        self.expandStateChangeNotifier = expandStateChangeNotifier
        
        titleLabel.text = "Game Description"
        descriptionLabel.text = """
            Los Santos: a sprawling sun-soaked metropolis full of self-help gurus, starlets and fading celebrities, once the envy of the Western world, now struggling to stay afloat in an era of economic uncertainty and cheap reality TV.

            Amidst the turmoil, three very different criminals plot their own chances of survival and success: Franklin, a street hustler looking for real opportunities and serious money; Michael, a professional ex-con whose retirement is a lot less rosy than he hoped it would be; and Trevor, a violent maniac driven by the chance of a cheap high and the next big score. Running out of options, the crew risks everything in a series of daring and dangerous heists that could set them up for life.

            The biggest, most dynamic and most diverse open world ever created, Grand Theft Auto V blends storytelling and gameplay in new ways as players repeatedly jump in and out of the lives of the game’s three lead characters, playing all sides of the game’s interwoven story.

            All the classic hallmarks of the groundbreaking series return, including incredible attention to detail and Grand Theft Auto’s darkly humorous take on modern culture, alongside a brand new and ambitious approach to open world multiplayer.

            Developed by series creators Rockstar North, Grand Theft Auto V is available worldwide for PC, PlayStation®4, PlayStation®3, Xbox One® and Xbox 360®.
        """
    }
    
    // MARK: ACTIONS
    
    @IBAction private func readMore(_ sender: UIButton) {
        isExpanded.toggle()
    }
    
}
