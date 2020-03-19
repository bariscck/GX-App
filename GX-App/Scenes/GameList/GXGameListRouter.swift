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
    
    static func build(viewState: GXGameListViewState) -> UIViewController {
        let viewModel = GXGameListViewModel(viewState: viewState,
                                            dependency: .init(gamesRepository: appContainer.gamesRepository,
                                                              favouritesRepository: appContainer.favouritesRepository))
        let router = GXGameListRouter()
        let viewController = GXGameListViewController(viewState: viewState,
                                                      viewModel: viewModel,
                                                      router: router)
        
        router.viewController = viewController
        
        return viewController
    }
    
    // MARK: ROUTING
 
    func pushGameDetailVC(for presentation: GXGamePresentation) {
        let gameDetailViewController = GXGameDetailRouter.build(presentation: presentation)
        viewController?.navigationController?.pushViewController(gameDetailViewController, animated: true)
    }
    
}
