//
//  GXImageLoader.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit.UIImageView
import Kingfisher

/**
 - GXImageLoader; async image loader and cache wrapper
 - Only uses UIImageView.
*/

protocol GXImageLoader {
    func loadRemoteImage(url: URL?, placeholder: UIImage?)
    func loadLocalImage(name: String)
}

extension UIImageView: GXImageLoader {
    func loadRemoteImage(url: URL?, placeholder: UIImage? = nil) {
        kf.setImage(with: url, placeholder: placeholder, options: [.transition(.fade(0.1))])
        kf.indicatorType = .activity
    }
    
    func loadLocalImage(name: String) {
        image = UIImage(named: name)
    }
}
