//
//  GXGameDetailRouter.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit.UIViewController
import SafariServices

protocol GXGameDetailRouterType {
    func openSFSafariController(for url: URL)
}

final class GXGameDetailRouter: GXGameDetailRouterType {
    
    // MARK: BUILDER
    
    private weak var viewController: UIViewController?
    
    static func build(presentation: GXGamePresentation, gamesRepository: GXGamesRepositoryType) -> UIViewController {
        let viewModel = GXGameDetailViewModel(dependency: .init(presentation: presentation, gamesRepository: gamesRepository))
        let router = GXGameDetailRouter()
        let viewController = GXGameDetailViewController(viewModel: viewModel,
                                                        router: router)
        
        router.viewController = viewController
        
        return viewController
    }
    
    // MARK: ROUTING
    
    func openSFSafariController(for url: URL) {
        let sfController = SFSafariViewController(url: url)
        viewController?.present(sfController, animated: true)
    }
    
}
