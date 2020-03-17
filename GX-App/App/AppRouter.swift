//
//  AppRouter.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit

final class AppRouter {
    
    // MARK: INITIALIZERS
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: MAIN
    
    func start() {
        let rootViewController = UIViewController()
        rootViewController.view.backgroundColor = .red
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
}
