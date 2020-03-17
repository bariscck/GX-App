//
//  GXGameListRouter.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit.UIViewController

protocol GXGameListRouterType {
    func pushGameDetailVC()
}

final class GXGameListRouter: GXGameListRouterType {
    
    // MARK: BUILDER
    
    private weak var viewController: UIViewController?
    
    static func build(gameService: GXGameServiceType) -> UIViewController {
        let viewModel = GXGameListViewModel(dependency: .init(gameService: gameService))
        let router = GXGameListRouter()
        let viewController = GXGameListViewController(viewModel: viewModel,
                                                      router: router)
        
        router.viewController = viewController
        
        return viewController
    }
    
    // MARK: ROUTING
 
    func pushGameDetailVC() {
        let gameDetailViewController = GXGameDetailRouter.build()
        viewController?.navigationController?.pushViewController(gameDetailViewController, animated: true)
    }
    
}
