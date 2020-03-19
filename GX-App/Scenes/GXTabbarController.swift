//
//  GXTabbarController.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 19.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit

final class GXTabbarController: UITabBarController {
    
    // MARK: INITIALIZERS
    
    private let networkAdapter: GXNetworkAdapter<GameXAPI>
    private let storageContext: GXStorageContext
    
    init(networkAdapter: GXNetworkAdapter<GameXAPI>, storageContext: GXStorageContext) {
        self.networkAdapter = networkAdapter
        self.storageContext = storageContext
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = GXTheme.primaryColor
        delegate = self
        
        viewControllers = [
            makeGameListVC(),
            makeFavouritesVC()
        ]
    }
    
    private func makeGameListVC() -> UIViewController {
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

extension GXTabbarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        GXFeedbackGenerator.generate()
    }
}
