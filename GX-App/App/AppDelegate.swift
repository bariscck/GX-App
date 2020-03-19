//
//  AppDelegate.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /**
         - Check iOS version
         * iOS 13+ versions uses SceneDelegate for window
         * iOS 13- versions users AppDelegate for window
         */
        if #available(iOS 13, *) {} else {
            // Setting window
            let window = UIWindow(frame: UIScreen.main.bounds)
            self.window = window
            // Starting App with AppContainer
            appContainer.start(in: window)
        }
        
        return true
    }


}

@available(iOS 13, *)
extension AppDelegate {
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
