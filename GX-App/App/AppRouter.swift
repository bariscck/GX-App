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
        let tabbarController = UITabBarController()
        tabbarController.tabBar.tintColor = GXTheme.primaryColor
        
        tabbarController.viewControllers = [
            makeGameListVC(),
            makeFavouritesVC()
        ]
        
        window.rootViewController = tabbarController
        window.makeKeyAndVisible()
    }
    
    private func makeGameListVC() -> UIViewController {
        let networkAdapter = GXNetworkAdapter<GameXAPI>()
        let storageContext = try! GXRealmStorageContext()
        let repository = GXGamesRepository(networkAdapter: networkAdapter, storageContext: storageContext)
        let gameListVC = GXGameListRouter.build(gamesRepository: repository)
        
        return makeNavController(rootViewController: gameListVC, with: UITabBarItem(title: "Games",
                                                                                    image: UIImage(named: "gamepad"),
                                                                                    selectedImage: nil))
    }
    
    private func makeFavouritesVC() -> UIViewController {
        let favouritesVC = GXFavouritesViewController()
        return makeNavController(rootViewController: favouritesVC, with: UITabBarItem(title: "Favourites",
                                                                                      image: UIImage(named: "favourites"),
                                                                                      selectedImage: nil))
    }
    
    // MARK: HELPERS
    
    private func makeNavController(rootViewController: UIViewController, with tabItem: UITabBarItem?) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        navigationController.view.backgroundColor = GXTheme.backgroundColor
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.tabBarItem = tabItem
        
        return navigationController
    }
    
}
