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
    
    private let gamesRepository: GXGamesRepositoryType
    private let favouritesRepository: GXFavouritesRepositoryType
    
    init(gamesRepository: GXGamesRepositoryType, favouritesRepository: GXFavouritesRepositoryType) {
        self.gamesRepository = gamesRepository
        self.favouritesRepository = favouritesRepository
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
            makeGameListVC(forViewState: .gameList),
            makeGameListVC(forViewState: .favourites)
        ]
    }
    
    private func makeGameListVC(forViewState state: GXGameListViewState) -> UIViewController {
        let gameListVC = GXGameListRouter.build(viewState: state)
        
        let tabbarItem: UITabBarItem
        // Setting tabbar item for state
        switch state {
        case .gameList:
            tabbarItem = UITabBarItem(title: "Games",
                                      image: UIImage(named: "gamepad"),
                                      selectedImage: nil)
        case .favourites:
            tabbarItem = UITabBarItem(title: "Favourites",
                                      image: UIImage(named: "favourites"),
                                      selectedImage: nil)
        }
        
        return makeNavController(rootViewController: gameListVC, with: tabbarItem)
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
        // Generate feedback when tabbar item selected
        GXFeedbackGenerator.generate()
    }
}
