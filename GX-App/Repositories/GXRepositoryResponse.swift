//
//  GXRepositoryResponseSource.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 19.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation

// If need repository response where to came from
// Use this response type
struct GXRepositoryResponse<T> {
    
    enum ResponseSource {
        case remote, local
    }
    
    let source: ResponseSource
    let result: T
    
}
