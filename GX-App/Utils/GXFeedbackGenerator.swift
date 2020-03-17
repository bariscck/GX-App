//
//  GXFeedbackGenerator.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit.UIImpactFeedbackGenerator

struct GXFeedbackGenerator {
    
    static private let generator = UIImpactFeedbackGenerator(style: .medium)
    private init() {}
    
    static func generate() {
        generator.impactOccurred()
    }
    
}
