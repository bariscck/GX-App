//
//  GXTheme.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit.UIColor

/**
 - GXTheme; cenral theme color manager
*/

enum GXTheme {
    static var primaryColor: UIColor {
        return assetColor(for: "PrimaryColor")
    }
    
    static var backgroundColor: UIColor {
        return assetColor(for: "BackgroundColor")
    }
    
    static var textPrimaryColor: UIColor {
        return assetColor(for: "TextPrimaryColor")
    }
    
    static var textSecondaryColor: UIColor {
        return assetColor(for: "TextSecondaryColor")
    }
    
    static var textTertiaryColor: UIColor {
        return assetColor(for: "TextSecondaryColor")
    }
    
    static var tableBackgroundColor: UIColor {
        return assetColor(for: "TableBackgroundColor")
    }
    
    static var tableGroupedBackgroundColor: UIColor {
        return assetColor(for: "TableGroupedBackgroundColor")
    }
    
    static var tableSelectedColor: UIColor {
        return assetColor(for: "TableSelectedColor")
    }
    
    static var redColor: UIColor {
        return assetColor(for: "RedColor")
    }
}

extension GXTheme {
    static func assetColor(for name: String) -> UIColor {
        guard let color = UIColor(named: name) else {
            fatalError("Error: color name '\(name)' is not found your xcassets folders.")
        }
        return color
    }
}
