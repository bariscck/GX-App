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
    private var gameService: GXGameServiceType?
    
    static func build(gameService: GXGameServiceType) -> UIViewController {
        let viewModel = GXGameListViewModel(dependency: .init(gameService: gameService))
        let router = GXGameListRouter()
        let viewController = GXGameListViewController(viewModel: viewModel,
                                                      router: router)
        
        router.viewController = viewController
        router.gameService = gameService
        
        return viewController
    }
    
    // MARK: ROUTING
 
    func pushGameDetailVC(for presentation: GXGamePresentation) {
        guard let gameService = gameService else {
            fatalError("Error: \(String(describing: self)) does not have \(String(describing: GXGameService.self))")
        }
        let gameDetailViewController = GXGameDetailRouter.build(presentation: presentation, gameService: gameService)
        viewController?.navigationController?.pushViewController(gameDetailViewController, animated: true)
    }
    
}
