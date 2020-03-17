//
//  GXGameDetailRouter.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit.UIViewController

protocol GXGameDetailRouterType {
    
}

final class GXGameDetailRouter: GXGameDetailRouterType {
    
    // MARK: BUILDER
    
    private weak var viewController: UIViewController?
    
    static func build(presentation: GXGamePresentation, gameService: GXGameServiceType) -> UIViewController {
        let viewModel = GXGameDetailViewModel(dependency: .init(presentation: presentation, gameService: gameService))
        let router = GXGameDetailRouter()
        let viewController = GXGameDetailViewController(viewModel: viewModel,
                                                        router: router)
        
        router.viewController = viewController
        
        return viewController
    }
    
}
