//
//  AppContainer.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit

final class AppContainer {
    
    // MARK: INITIALIZERS
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: DEPENDENCIES
    
    private let networkAdapter = GXNetworkAdapter<GameXAPI>()
    private let storageContext = try! GXRealmStorageContext()
    
    // MARK: MAIN
    
    func start() {
        let rootViewController = GXTabbarController(networkAdapter: networkAdapter,
                                                    storageContext: storageContext)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
}
