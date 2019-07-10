//
//  AppDelegate.swift
//  Erised
//
//  Created by David Linhares on 27/06/2019.
//  Copyright © 2019 David Linhares. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        if (AppFileManager.Config.getFileContent().isEmpty) {
            window.rootViewController = AppStoryboard.Configuration.instantiateInitialViewController()
        } else {
            window.rootViewController = AppStoryboard.Home.instantiateInitialViewController()
        }

        window.makeKeyAndVisible()

        self.window = window

        return true
    }
}

