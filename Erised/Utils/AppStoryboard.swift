//
//  AppStoryboard.swift
//  myges
//
//  Created by Stephane Guardo on 25/03/2019.
//  Copyright © 2019 Réseau GES. All rights reserved.
//

import UIKit

enum AppStoryboard : String {
    case Home
    case Configuration
    
    /*
     Get the storyboard instance
     Example: AppStroryboard.Main.instance will return UIStoryboard for Main storyboard
     */
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    /*
     Get the UIViewController instance for a controller contained in a storyboard
     Example: AppStroryboard.Main.viewController(viewControllerClass) will return an instance of UIVIewController
     based on  the ID set in the storyboard for the controller
     */
    func viewController<T: UIViewController>(viewControllerClass : T.Type) -> T {
        return instance.instantiateViewController(withIdentifier: (viewControllerClass as UIViewController.Type).storyboardID) as! T
    }
    
    /*
     Get the UIViewController instance for the rootViewController
     Example: AppStroryboard.Main.instantiateInitialViewController() will return an instance of the entry point in the storyboard
     */
    func instantiateInitialViewController() -> UIViewController {
        return self.instance.instantiateInitialViewController()!
    }
}


