//
//  GXStorageConfiguration.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 18.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation

/* Storage config options */
public enum GXConfigurationType {
    case basic(url: String?)
    case inMemory(identifier: String?)
    
    var associated: String? {
        get {
            switch self {
            case .basic(let url)            : return url
            case .inMemory(let identifier)  : return identifier
            }
        }
    }
}
