//
//  GXGameListRouter.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit.UIViewController

protocol GXGameListRouterType {
    func pushGameDetailVC(for presentation: GXGamePresentation)
}

final class GXGameListRouter: GXGameListRouterType {
    
    // MARK: BUILDER
    
    private weak var viewController: UIViewController?
    private var gamesRepository: GXGamesRepositoryType?
    
    static func build(gamesRepository: GXGamesRepositoryType) -> UIViewController {
        let viewModel = GXGameListViewModel(dependency: .init(gamesRepository: gamesRepository))
        let router = GXGameListRouter()
        let viewController = GXGameListViewController(viewModel: viewModel,
                                                      router: router)
        
        router.viewController = viewController
        router.gamesRepository = gamesRepository
        
        return viewController
    }
    
    // MARK: ROUTING
 
    func pushGameDetailVC(for presentation: GXGamePresentation) {
        guard let gamesRepository = gamesRepository else {
            fatalError("Error: \(String(describing: self)) does not have \(String(describing: GXGamesRepositoryType.self))")
        }
        let gameDetailViewController = GXGameDetailRouter.build(presentation: presentation, gamesRepository: gamesRepository)
        viewController?.navigationController?.pushViewController(gameDetailViewController, animated: true)
    }
    
}
