//
//  GXConfigs.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 21.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation

struct GXConfigs {
    
    private init() {}
    
    enum ConfigType: String {
        case serverURL = "SERVER_URL"
    }
    
    static func loadConfig(type: ConfigType) -> String {
        return Bundle.main.loadFromPlist(plist: "Info", for: type.rawValue)
    }
    
}
