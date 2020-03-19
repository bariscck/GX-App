//
//  AppContainer.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit

let appContainer = AppContainer()

final class AppContainer {
    
    // MARK: DEPENDENCIES
    
    private let networkAdapter = GXNetworkAdapter<GameXAPI>()
    private let storageContext = try! GXRealmStorageContext()
    
    public lazy var gamesRepository = GXGamesRepository(networkAdapter: networkAdapter,
                                                         storageContext: storageContext)
    
    public lazy var favouritesRepository = GXFavouritesRepository(storageContext: storageContext)
    
    // MARK: ROUTING
    
    func start(in window: UIWindow) {
        let rootViewController = GXTabbarController(gamesRepository: gamesRepository,
                                                    favouritesRepository: favouritesRepository)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
}
