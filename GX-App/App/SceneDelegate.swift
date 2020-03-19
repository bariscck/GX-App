//
//  SceneDelegate.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit

@available(iOS 13, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let wScene = (scene as? UIWindowScene) else { return }
        /**
         - Setting window
         */
        let window = UIWindow(windowScene: wScene)
        self.window = window
        /**
         - Starting App with AppContainer in window
         */
        appContainer.start(in: window)
    }


}

