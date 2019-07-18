//
//  UiViewControllerStoryboardExtended.swift
//  myges
//
//  Created by Stephane Guardo on 25/03/2019.
//  Copyright © 2019 Réseau GES. All rights reserved.
//

import UIKit

extension UIViewController {
    /*
     Convert UIViewController class name into string in order to use it has an ID for storyboards
     */
    class var storyboardID: String {
        return "\(self)"
    }
    
    /*
     Enable to instantiate a view controller inside a storyboard directly from the viewcontroller class itself
     */
    static func instantiate(FromAppStoryboard appStoryboard : AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
    /*
     Present a new controller and destroy all the controllers contained in the navigation controller
     in order to set the new controller has the only one in the stack
     */
    func presentAndDestroy(_ viewControllerToPresent: UIViewController, animated: Bool) {
        self.present(viewControllerToPresent, animated: animated) {
            self.navigationController?.viewControllers.removeAll()
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func hideKeyboardWhenSwippedAround() {
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        swipe.direction = [.up, .down]
        self.view.addGestureRecognizer(swipe)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

