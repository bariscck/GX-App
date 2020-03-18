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
        let networkAdapter = GXNetworkAdapter<GameXAPI>()
        let storageContext = try! GXRealmStorageContext()
        let repository = GXGamesRepository(networkAdapter: networkAdapter, storageContext: storageContext)
        let gameListVC = GXGameListRouter.build(gamesRepository: repository)
        return gameListVC
    }
    
}
