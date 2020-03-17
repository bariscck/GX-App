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
        let rootViewController = makeGameListVC()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func makeGameListVC() -> UIViewController {
        let gameService = GXGameService()
        let gameListVC = GXGameListRouter.build(gameService: gameService)
        return gameListVC
    }
    
}
